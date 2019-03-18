use failure::{err_msg, Error};
use futures::future;
use futures::future::Future;
use mio;
use mio::net::{TcpListener, TcpStream};
use slab::Slab;
use std::io::{Read, Write};
use std::net::{Shutdown, SocketAddr};
use std::sync::{mpsc, Arc};
use std::{thread, time};
use tokio;
use tokio::runtime::Runtime;
use trust_dns_resolver;
use trust_dns_resolver::config::{ResolverConfig, ResolverOpts};
use trust_dns_resolver::AsyncResolver;

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
pub enum Responses {
    Ips(trust_dns_resolver::lookup_ip::LookupIp),
    Event(mio::event::Event),
}

#[derive(Debug)]
enum NetTcp {
    Listener(TcpListener),
    Stream(TcpStream),
}

#[derive(Debug)]
pub struct NetLoop {
    runtime: Runtime,
    resolver: AsyncResolver,
    poll: Arc<mio::Poll>,
    pub is_listening: bool,
    slab: Slab<NetTcp>,
    event_receiver: mpsc::Receiver<Result<Responses, Error>>,
    event_sender: mpsc::Sender<Result<Responses, Error>>,
}

impl Default for NetLoop {
    fn default() -> Self {
        Self::new()
    }
}

impl NetLoop {
    pub fn new() -> Self {
        let poll = Arc::new(mio::Poll::new().unwrap());
        let (event_sender, event_receiver) = mpsc::channel();
        let es = event_sender.clone();
        let t_poll = poll.clone();
        thread::spawn(move || {
            let mut events = mio::Events::with_capacity(1024);
            loop {
                t_poll.poll(&mut events, None).unwrap();
                for event in events.iter() {
                    es.send(Ok(Responses::Event(event))).unwrap();
                }
            }
        });

        let mut runtime = Runtime::new().unwrap();
        let (resolver, background) =
            AsyncResolver::new(ResolverConfig::default(), ResolverOpts::default());
        runtime.spawn(background);
        Self {
            slab: Slab::new(),
            runtime,
            is_listening: false,
            poll,
            resolver,
            event_receiver,
            event_sender,
        }
    }
    pub fn lookup_ip(&mut self, addr: &str) {
        let es = self.event_sender.clone();
        self.runtime
            .spawn(self.resolver.lookup_ip(addr).then(move |result| {
                match result {
                    Err(err) => es.send(Err(err.into())).unwrap(),
                    Ok(lookup) => es.send(Ok(Responses::Ips(lookup))).unwrap(),
                };
                future::ok(())
            }));
    }
    pub fn try_recv(&mut self) -> Result<Responses, Error> {
        self.event_receiver.try_recv()?
    }
    pub fn recv(&mut self) -> Result<Responses, Error> {
        self.event_receiver.recv()?
    }
    pub fn recv_timeout(&mut self, timeout: time::Duration) -> Result<Responses, Error> {
        self.event_receiver.recv_timeout(timeout)?
    }
    pub fn tcp_listen(&mut self, addr: &SocketAddr) -> Result<usize, Error> {
        let listener = TcpListener::bind(addr)?;
        let id = self.slab.insert(NetTcp::Listener(listener));
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
        let id = self.slab.insert(NetTcp::Stream(stream));
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
            NetTcp::Listener(listener) => listener.take_error().map_err(|e| e.into()),
            NetTcp::Stream(stream) => stream.take_error().map_err(|e| e.into()),
        }
    }
    pub fn local_addr(&self, i: usize) -> Result<SocketAddr, Error> {
        match self.slab_get(i)? {
            NetTcp::Listener(listener) => listener.local_addr().map_err(|e| e.into()),
            NetTcp::Stream(stream) => stream.local_addr().map_err(|e| e.into()),
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
    pub fn close(&mut self, i: usize) -> Result<(), Error> {
        if self.slab.contains(i) {
            self.slab.remove(i); // value is dropped and connection is closed
        };
        Ok(())
    }
    fn slab_get(&self, i: usize) -> Result<&NetTcp, Error> {
        match self.slab.get(i) {
            Some(ntcp) => Ok(ntcp),
            None => Err(err_msg("Network object not found in slab")),
        }
    }
    fn get_listener_ref(&self, i: usize) -> Result<&TcpListener, Error> {
        match self.slab_get(i)? {
            NetTcp::Listener(listener) => Ok(listener),
            _ => Err(err_msg("Network object not found in slab")),
        }
    }
    fn get_stream_ref(&self, i: usize) -> Result<&TcpStream, Error> {
        match self.slab_get(i)? {
            NetTcp::Stream(s) => Ok(s),
            _ => Err(err_msg("Network object not found in slab")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    pub fn as_u16_le(array: &[u8]) -> u16 {
        u16::from(array[0]) | (u16::from(array[1]) << 8)
    }

    #[test]
    fn it_works() {
        let mut nl = NetLoop::new();
        nl.lookup_ip("www.google.com.");
        println!("Got {:?}", nl.event_receiver.recv().unwrap());
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
        let mut nl = NetLoop::new();
        let listener = nl.tcp_listen(&"127.0.0.1:34254".parse().unwrap()).unwrap();
        let conn = nl.tcp_connect(&"127.0.0.1:34254".parse().unwrap()).unwrap();

        let to_write = [0, 1, 2, 3, 4, 5, 6, 7, 8];
        loop {
            if let Responses::Event(event) = nl.event_receiver.recv().unwrap().unwrap() {
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
                panic!("no");
            }
        }
    }
}
