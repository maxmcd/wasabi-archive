//! Wasabi io
//!
//! This module contains a struct IOLoop that handles all kinds of IO. Networking
//! is implemented using mio and a single event thread. Filesystem io and dns is
//! handled with tokio and trust-dns. A simple chroot is implemented for the
//! filesystem. More resoure limiting and access rules will be added in the future.

#![deny(
    // missing_docs,
    trivial_numeric_casts,
    unstable_features,
    unused_extern_crates,
    unused_features
)]
#![warn(unused_import_braces, unused_parens)]
#![cfg_attr(feature = "clippy", plugin(clippy(conf_file = "../../clippy.toml")))]
#![cfg_attr(
    feature = "cargo-clippy",
    allow(clippy::new_without_default, clippy::new_without_default_derive)
)]
#![cfg_attr(
    feature = "cargo-clippy",
    warn(
        clippy::float_arithmetic,
        clippy::mut_mut,
        clippy::nonminimal_bool,
        clippy::option_map_unwrap_or,
        clippy::option_map_unwrap_or_else,
        clippy::unicode_not_nfc,
        clippy::use_self
    )
)]

use failure::{err_msg, Error};
use futures::future;
use futures::Future;
use mio;
use mio::net::{TcpListener, TcpStream};
use path_dedot::ParseDot;
use slab::Slab;
use std::env::current_dir;
use std::fs;
use std::io::{Read, SeekFrom, Write};
use std::net::{Shutdown, SocketAddr};
use std::path::PathBuf;
use std::sync::{mpsc, Arc};
use std::{thread, time};
use tokio;
use tokio::fs::{metadata, OpenOptions};
use tokio::runtime::Runtime;
use trust_dns_resolver;
use trust_dns_resolver::config::{ResolverConfig, ResolverOpts};
use trust_dns_resolver::AsyncResolver;

/// O_WRONLY openmode bitmask
pub const O_WRONLY: i64 = 1;
/// O_RDWR openmode bitmask
pub const O_RDWR: i64 = 2;
/// O_CREAT openmode bitmask
pub const O_CREAT: i64 = 64;
/// O_TRUNC openmode bitmask
pub const O_TRUNC: i64 = 512;
/// O_APPEND openmode bitmask
pub const O_APPEND: i64 = 1024;
/// O_EXCL openmode bitmask
pub const O_EXCL: i64 = 128;

/// converts a mio event to a token id and event bitarray
/// the first four bits correlate to: readable, writeable, is_hup, is_error
pub fn event_to_ints(event: &mio::Event) -> ((i64, i64)) {
    // 0 << 0 | 1 << 1 | 0 << 2 | 1 << 3

    let unix_ready = mio::unix::UnixReady::from(event.readiness());
    let state: i64 = if unix_ready.is_readable() { 1 } else { 0 }
        | if unix_ready.is_writable() {
            1 << 1
        } else {
            0 << 1
        }
        | if unix_ready.is_hup() { 1 << 2 } else { 0 << 2 }
        | if unix_ready.is_error() {
            1 << 3
        } else {
            0 << 3
        };
    (event.token().0 as i64, state)
}

fn u16_as_u8_le(x: u16) -> [u8; 2] {
    [(x & 0xff) as u8, ((x >> 8) & 0xff) as u8]
}

/// writes an ipv4 socket address as bytes to a u8 array
pub fn addr_to_bytes(addr: SocketAddr, b: &mut [u8]) -> Result<(), Error> {
    match addr {
        SocketAddr::V4(a) => {
            b[0..4].copy_from_slice(&a.ip().octets());
            b[4..6].copy_from_slice(&u16_as_u8_le(a.port()));
            Ok(())
        }
        SocketAddr::V6(_) => Err(err_msg("IPV6 not supported")),
    }
}

#[derive(Debug)]
pub enum Response {
    Error {
        id: i64,
        msg: String,
    },
    Ips {
        id: i64,
        ips: trust_dns_resolver::lookup_ip::LookupIp,
    },
    Metadata {
        id: i64,
        md: fs::Metadata,
    },
    FileRef {
        id: i64,
        fd: usize,
    },
    Read {
        id: i64,
        len: usize,
        buf: Vec<u8>,
    },
    Success {
        id: i64,
    },
    File {
        id: i64,
        file: tokio::fs::File,
    },
    Event(mio::event::Event),
}

impl Response {
    pub fn id(&self) -> Option<i64> {
        match self {
            Response::File { id, .. } => Some(*id),
            Response::Success { id, .. } => Some(*id),
            Response::Read { id, .. } => Some(*id),
            Response::Error { id, .. } => Some(*id),
            Response::Ips { id, .. } => Some(*id),
            Response::Metadata { id, .. } => Some(*id),
            Response::FileRef { id, .. } => Some(*id),
            Response::Event(_) => None,
        }
    }
}

trait ToResponse {
    fn to_response(self, id: i64) -> Response;
}

impl ToResponse for tokio::fs::File {
    fn to_response(self, id: i64) -> Response {
        Response::File { file: self, id }
    }
}

impl ToResponse for (tokio::fs::File, Vec<u8>, usize) {
    fn to_response(self, id: i64) -> Response {
        Response::Read {
            buf: self.1,
            id,
            len: self.2,
        }
    }
}

impl ToResponse for () {
    fn to_response(self, id: i64) -> Response {
        Response::Success { id }
    }
}

impl ToResponse for (tokio::io::Stdout, Vec<u8>) {
    fn to_response(self, id: i64) -> Response {
        Response::Success { id }
    }
}

impl ToResponse for (tokio::io::Stderr, Vec<u8>) {
    fn to_response(self, id: i64) -> Response {
        Response::Success { id }
    }
}

impl ToResponse for (tokio::fs::File, Vec<u8>) {
    fn to_response(self, id: i64) -> Response {
        Response::Success { id }
    }
}

impl ToResponse for fs::Metadata {
    fn to_response(self, id: i64) -> Response {
        Response::Metadata { md: self, id }
    }
}

fn send_result(
    id: i64,
    es: mpsc::Sender<Response>,
    result: Result<impl ToResponse, std::io::Error>,
) -> impl Future<Item = (), Error = ()> {
    match result {
        Err(err) => es
            .send(Response::Error {
                msg: err.to_string(),
                id,
            })
            .unwrap(),
        Ok(tr) => es.send(tr.to_response(id)).unwrap(),
    };
    future::ok(())
}

#[derive(Debug)]
enum Tcp {
    Listener(TcpListener),
    Stream(TcpStream),
}

#[derive(Debug)]
pub struct IOLoop {
    event_receiver: mpsc::Receiver<Response>,
    event_sender: mpsc::Sender<Response>,
    pub is_listening: bool,
    path: PathBuf,
    runtime_cwd: PathBuf,
    poll: Arc<mio::Poll>,
    resolver: AsyncResolver,
    runtime: Runtime,
    slab: Slab<Tcp>,
    files: Slab<std::fs::File>,
}

impl Default for IOLoop {
    fn default() -> Self {
        Self::new()
    }
}

impl IOLoop {
    pub fn new() -> Self {
        let poll = Arc::new(mio::Poll::new().unwrap());
        let (event_sender, event_receiver) = mpsc::channel();
        let es = event_sender.clone();
        let t_poll = poll.clone();

        // Spawn a thread for mio events
        thread::spawn(move || {
            let mut events = mio::Events::with_capacity(1024);
            loop {
                t_poll.poll(&mut events, None).unwrap();
                for event in events.iter() {
                    if es.send(Response::Event(event)).is_err() {
                        // the receiver has been dropped, so we can
                        // proceed with quitting
                        break;
                    }
                }
            }
        });

        // let's guarantee order for now, we can make performance changes later
        let mut runtime = tokio::runtime::Builder::new()
            .core_threads(1)
            .build()
            .unwrap();
        let (resolver, background) =
            AsyncResolver::new(ResolverConfig::default(), ResolverOpts::default());
        runtime.spawn(background);

        Self {
            event_receiver,
            event_sender,
            is_listening: false,
            path: PathBuf::from("/"),
            poll,
            resolver,
            runtime_cwd: current_dir().unwrap(),
            runtime,
            slab: Slab::new(),
            files: Slab::new(),
        }
    }
    pub fn metadata(&mut self, id: i64, name: String) {
        let es = self.event_sender.clone();
        self.runtime
            .spawn(metadata(name).then(move |result| send_result(id, es, result)));
    }
    pub fn lookup_ip(&mut self, id: i64, addr: &str) {
        let es = self.event_sender.clone();
        self.runtime
            .spawn(self.resolver.lookup_ip(addr).then(move |result| {
                match result {
                    Err(err) => es
                        .send(Response::Error {
                            msg: err.to_string(),
                            id,
                        })
                        .unwrap(),
                    Ok(ips) => es.send(Response::Ips { ips, id }).unwrap(),
                };
                future::ok(())
            }));
    }
    pub fn cwd(&self) -> &str {
        self.path.to_str().unwrap()
    }
    pub fn chdir(&mut self, path: &str) {
        self.path = self.resolve_path(path);
    }
    fn resolve_path(&self, path: &str) -> PathBuf {
        // https://github.com/magiclen/path-dedot/blob/master/src/unix.rs
        // this unwrap actually seems 100% safe
        self.path.join(PathBuf::from(path)).parse_dot().unwrap()
    }
    fn real_path(&self, path: &str) -> PathBuf {
        self.runtime_cwd.join(
            PathBuf::from(String::from(".") + self.resolve_path(path).to_str().unwrap())
                .parse_dot()
                .unwrap(),
        )
    }
    pub fn fs_mkdir(&mut self, id: i64, path: String) {
        let es = self.event_sender.clone();
        self.runtime.spawn(
            tokio::fs::create_dir(self.real_path(&path))
                .then(move |result| send_result(id, es, result)),
        );
    }
    pub fn fs_close(&mut self, fd: usize) {
        self.files.remove(fd);
    }
    pub fn stderr(&mut self, id: i64, buf: Vec<u8>) {
        let es = self.event_sender.clone();
        self.runtime.spawn(
            tokio::io::write_all(tokio::io::stderr(), buf)
                .then(move |result| send_result(id, es, result)),
        );
    }
    pub fn stdout(&mut self, id: i64, buf: Vec<u8>) {
        let es = self.event_sender.clone();
        self.runtime.spawn(
            tokio::io::write_all(tokio::io::stdout(), buf)
                .then(move |result| send_result(id, es, result)),
        );
    }
    pub fn fs_write(&mut self, id: i64, fd: usize, buf: Vec<u8>) {
        // TODO: should be able to pass around a lifetime for vec that
        // allows us to send it without allocating a new object
        let f = self.files.get(fd).unwrap().try_clone().unwrap();
        let tf = tokio::fs::File::from_std(f);
        let es = self.event_sender.clone();
        self.runtime.spawn(
            tf.seek(SeekFrom::Start(0)) // TODO: pass this value to the function. also race conditions?
                .and_then(|(tf, _)| tokio::io::write_all(tf, buf))
                .then(move |result| send_result(id, es, result)),
        );
    }
    pub fn fs_read(&mut self, id: i64, fd: usize, buf: Vec<u8>) {
        // TODO: should be able to pass around a lifetime for vec that
        // allows us to send it without allocating a new object
        let f = self.files.get(fd).unwrap().try_clone().unwrap();
        let tf = tokio::fs::File::from_std(f);
        let es = self.event_sender.clone();
        self.runtime.spawn(
            tf.seek(SeekFrom::Start(0)) // TODO: pass this value to the function. also race conditions?
                .and_then(|(tf, _)| tokio::io::read(tf, buf))
                .then(move |result| send_result(id, es, result)),
        );
    }
    fn open_options(openmode: i64) -> OpenOptions {
        let (read, write) = if openmode & O_RDWR > 0 {
            (true, true)
        } else if openmode & O_WRONLY > 0 {
            (false, true)
        } else {
            (true, false)
        };

        OpenOptions::new()
            .read(read)
            .write(write)
            .append(openmode & O_APPEND > 0)
            .create(openmode & O_CREAT > 0)
            .truncate(openmode & O_TRUNC > 0)
            .clone()
    }
    pub fn fs_open(&mut self, id: i64, path: String, openmode: i64, _perm: i32) {
        let es = self.event_sender.clone();

        // TODO: set perms on returned file if we create
        self.runtime.spawn(
            Self::open_options(openmode)
                .open(path)
                .then(move |result| send_result(id, es, result)),
        );
    }
    fn recv_wrapper(&mut self, r: Result<Response, Error>) -> Result<Response, Error> {
        if let Ok(resp) = r {
            // TODO: this is likely excessive if fs_open is the only thing
            // opening or creating files. remove and put in fs_open if that's
            // the case
            if let Response::File { id, file } = resp {
                // keep the file and return a virtual fd and the id
                Ok(Response::FileRef {
                    fd: self.files.insert(file.into_std()),
                    id,
                })
            } else {
                Ok(resp)
            }
        } else {
            r
        }
    }
    pub fn try_recv(&mut self) -> Result<Response, Error> {
        self.recv_wrapper(self.event_receiver.try_recv().map_err(|e| e.into()))
    }
    pub fn recv(&mut self) -> Result<Response, Error> {
        self.recv_wrapper(self.event_receiver.recv().map_err(|e| e.into()))
    }
    pub fn recv_timeout(&mut self, timeout: time::Duration) -> Result<Response, Error> {
        self.recv_wrapper(
            self.event_receiver
                .recv_timeout(timeout)
                .map_err(|e| e.into()),
        )
    }
    pub fn tcp_listen(&mut self, addr: &SocketAddr) -> Result<usize, Error> {
        let listener = TcpListener::bind(addr)?;
        let id = self.slab.insert(Tcp::Listener(listener));
        self.poll.register(
            self.get_listener_ref(id)?,
            mio::Token(id),
            mio::Ready::readable() | mio::Ready::writable(),
            // https://carllerche.github.io/mio/mio/struct.Poll.html#edge-triggered-and-level-triggered
            mio::PollOpt::edge(),
        )?;
        self.is_listening = true;
        Ok(id)
    }
    pub fn tcp_connect(&mut self, addr: &SocketAddr) -> Result<usize, Error> {
        let stream = TcpStream::connect(addr)?;
        self.is_listening = true;
        self.register_stream(stream)
    }
    fn register_stream(&mut self, stream: TcpStream) -> Result<usize, Error> {
        let id = self.slab.insert(Tcp::Stream(stream));
        self.poll.register(
            self.get_stream_ref(id)?,
            mio::Token(id),
            mio::Ready::readable() | mio::Ready::writable(),
            mio::PollOpt::edge(),
        )?;
        Ok(id)
    }
    pub fn tcp_accept(&mut self, id: usize) -> Result<usize, Error> {
        let (stream, _) = self.get_listener_ref(id)?.accept()?;
        self.register_stream(stream)
    }
    pub fn get_error(&mut self, id: usize) -> Result<Option<std::io::Error>, Error> {
        match self.slab_get(id)? {
            Tcp::Listener(listener) => listener.take_error().map_err(|e| e.into()),
            Tcp::Stream(stream) => stream.take_error().map_err(|e| e.into()),
        }
    }
    pub fn local_addr(&self, i: usize) -> Result<SocketAddr, Error> {
        match self.slab_get(i)? {
            Tcp::Listener(listener) => listener.local_addr().map_err(|e| e.into()),
            Tcp::Stream(stream) => stream.local_addr().map_err(|e| e.into()),
        }
    }
    pub fn peer_addr(&self, i: usize) -> Result<SocketAddr, Error> {
        self.get_stream_ref(i)?.peer_addr().map_err(|e| e.into())
    }
    pub fn read_stream(&self, i: usize, b: &mut [u8]) -> Result<usize, Error> {
        self.get_stream_ref(i)?.read(b).map_err(|e| e.into())
    }
    pub fn shutdown(&mut self, i: usize, how: Shutdown) -> Result<(), Error> {
        self.get_stream_ref(i)?.shutdown(how).map_err(|e| e.into())
    }
    pub fn write_stream(&self, i: usize, b: &[u8]) -> Result<usize, Error> {
        self.get_stream_ref(i)?.write(b).map_err(|e| e.into())
    }
    pub fn close_conn(&mut self, i: usize) -> Result<(), Error> {
        if self.slab.contains(i) {
            self.slab.remove(i); // value is dropped and connection is closed
        };
        Ok(())
    }
    fn slab_get(&self, i: usize) -> Result<&Tcp, Error> {
        match self.slab.get(i) {
            Some(ntcp) => Ok(ntcp),
            None => Err(err_msg("Network object not found in slab")),
        }
    }
    fn get_listener_ref(&self, i: usize) -> Result<&TcpListener, Error> {
        match self.slab_get(i)? {
            Tcp::Listener(listener) => Ok(listener),
            _ => Err(err_msg("Network object not found in slab")),
        }
    }
    fn get_stream_ref(&self, i: usize) -> Result<&TcpStream, Error> {
        match self.slab_get(i)? {
            Tcp::Stream(s) => Ok(s),
            _ => Err(err_msg("Network object not found in slab")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::net::{IpAddr, Ipv4Addr};
    use tempfile::Builder;

    pub fn as_u16_le(array: &[u8]) -> u16 {
        u16::from(array[0]) | (u16::from(array[1]) << 8)
    }

    #[test]
    fn file_io() {
        let mut nl = IOLoop::new();
        let file = Builder::new().tempfile_in(nl.real_path(".")).unwrap();
        let path = file
            .path()
            .file_name()
            .unwrap()
            .to_str()
            .unwrap()
            .to_string();

        let cb_id = 200;
        nl.fs_open(cb_id, path, O_RDWR, 0);

        let fd = if let Response::FileRef { fd, id } = nl.recv().unwrap() {
            assert_eq!(cb_id, id);
            fd
        } else {
            panic!("Wrong type returned");
        };

        nl.fs_write(0, fd, "Hello".as_bytes().to_vec());
        nl.recv().unwrap();

        let buf = vec![0; 100];
        let cb_id = 20;
        nl.fs_read(cb_id, fd, buf);

        if let Response::Read { buf, id, len } = nl.recv().unwrap() {
            assert_eq!(len, "Hello".len());
            assert_eq!(&buf[..len], "Hello".as_bytes());
            assert_eq!(cb_id, id);
        } else {
            panic!("Wrong type returned");
        };
    }

    #[test]
    fn realpath() {
        let mut nl = IOLoop::new();
        nl.chdir("/foo");
        let mut cd = current_dir().unwrap();
        cd.push("foo");
        assert_eq!(nl.real_path("."), cd);
    }

    #[test]
    fn stdio() {
        let mut nl = IOLoop::new();
        nl.stdout(0, "Hello stdout\n".as_bytes().to_vec());
        nl.stderr(1, "Hello stderr\n".as_bytes().to_vec());
        println!("I should be first");
        // should confirm printing happened

        if let Response::Success { id } = nl.recv().unwrap() {
            assert_eq!(0, id);
        } else {
            panic!("Wrong type returned");
        };
        if let Response::Success { id } = nl.recv().unwrap() {
            assert_eq!(1, id);
        } else {
            panic!("Wrong type returned");
        };
    }

    #[test]
    fn ensure_chroot() {
        let mut nl = IOLoop::new();
        assert_eq!("/", nl.cwd());
        nl.chdir("../../../");
        assert_eq!("/", nl.cwd());
    }

    #[test]
    fn lookup_ip_localhost() {
        let mut nl = IOLoop::new();
        nl.lookup_ip(0, "localhost");
        if let Response::Ips { ips, id } = nl.recv().unwrap() {
            assert_eq!(id, 0);
            if let IpAddr::V4(ip) = ips.iter().next().unwrap() {
                assert_eq!(ip, Ipv4Addr::new(127, 0, 0, 1));
            } else {
                panic!("ipv4 expected");
            }
        } else {
            panic!("expected Response::Event");
        }
    }

    #[test]
    fn test_addr_to_bytes() {
        let mut mem = vec![0u8; 6];
        addr_to_bytes("1.2.3.4:100".parse().unwrap(), &mut mem).unwrap();
        assert_eq!(mem, [1, 2, 3, 4, 100, 0]);

        let mut mem = vec![0u8; 6];
        addr_to_bytes("127.0.0.1:34254".parse().unwrap(), &mut mem).unwrap();
        assert_eq!(as_u16_le(&mem[4..6]), 34254u16);
    }

    #[test]
    fn listen_connect_read_write() {
        let mut nl = IOLoop::new();
        let listener = nl.tcp_listen(&"127.0.0.1:0".parse().unwrap()).unwrap();
        let conn = nl
            .tcp_connect(&nl.get_listener_ref(listener).unwrap().local_addr().unwrap())
            .unwrap();

        let to_write = [0, 1, 2, 3, 4, 5, 6, 7, 8];
        loop {
            if let Response::Event(event) = nl.recv().unwrap() {
                if event.token().0 == conn && event.readiness().is_writable() {
                    nl.write_stream(event.token().0, &to_write).unwrap();
                } else if event.token().0 == listener && event.readiness().is_readable() {
                    nl.tcp_accept(event.token().0).unwrap();
                } else if event.token().0 == 2 && event.readiness().is_readable() {
                    let mut b = [0; 9];
                    nl.read_stream(event.token().0, &mut b).unwrap();
                    assert_eq!(b, to_write);
                    break;
                // listener connection
                } else {
                    continue;
                }
            } else {
                panic!("expected a Response::Event!");
            }
        }
    }
}
