use mio;
use mio::net;
use slab::Slab;
use std::io::{Error, ErrorKind, Read, Result, Write};
use std::net::SocketAddr;
use std::result;
use std::sync::mpsc;
use std::sync::Arc;
use std::thread;

#[derive(Debug)]
enum NetTcp {
    Listener(mio::net::TcpListener),
    Stream(mio::net::TcpStream),
}

#[derive(Debug)]
pub struct NetLoop {
    slab: Slab<NetTcp>,
    poll: Arc<mio::Poll>,
    pub is_listening: bool,
    event_receiver: mpsc::Receiver<mio::event::Event>,
}

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

impl NetLoop {
    pub fn new() -> Self {
        let poll = Arc::new(mio::Poll::new().unwrap());
        let (event_sender, event_receiver) = mpsc::channel();
        let t_poll = poll.clone();
        thread::spawn(move || {
            let mut events = mio::Events::with_capacity(1024);
            loop {
                t_poll.poll(&mut events, None).unwrap();
                for event in events.iter() {
                    println!("Got event in network.rs event loop {:?}", event);
                    event_sender.send(event).unwrap();
                }
            }
        });
        Self {
            slab: Slab::new(),
            is_listening: false,
            poll,
            event_receiver,
        }
    }
    fn process_event(&mut self, event: &mio::Event) {
        let unix_ready = mio::unix::UnixReady::from(event.readiness());
        if unix_ready.is_hup() {
            self.slab.remove(event.token().0);
            // this might be a little too aggressive
            // slab remove should drop any refernece to the Stream or Listener
            // but it's unclear if the id is still being used under the hood
            // the next generated id is always the one most recently used...
        };
    }
    pub fn try_recv(&mut self) -> result::Result<mio::Event, mpsc::TryRecvError> {
        match self.event_receiver.try_recv() {
            Ok(event) => {
                self.process_event(&event);
                Ok(event)
            }
            Err(err) => Err(err),
        }
    }
    pub fn recv(&mut self) -> result::Result<mio::Event, mpsc::RecvError> {
        match self.event_receiver.recv() {
            Ok(event) => {
                self.process_event(&event);
                Ok(event)
            }
            Err(err) => Err(err),
        }
    }

    // fn register(&mut self, addr)
    pub fn tcp_listen(&mut self, addr: &SocketAddr) -> Result<usize> {
        let listener = net::TcpListener::bind(addr)?;
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
    pub fn tcp_connect(&mut self, addr: &SocketAddr) -> Result<usize> {
        let stream = net::TcpStream::connect(addr)?;
        self.is_listening = true;
        self.register_stream(stream)
    }
    fn register_stream(&mut self, stream: mio::net::TcpStream) -> Result<usize> {
        let id = self.slab.insert(NetTcp::Stream(stream));
        self.poll.register(
            self.get_stream_ref(id)?,
            mio::Token(id),
            mio::Ready::readable() | mio::Ready::writable(),
            mio::PollOpt::edge(),
        )?;
        Ok(id)
    }
    pub fn tcp_accept(&mut self, id: usize) -> Result<usize> {
        // TODO: handle connection metadata
        let (stream, _) = self.get_listener_ref(id)?.accept()?;
        self.register_stream(stream)
    }
    pub fn read_stream(&self, i: usize, b: &mut [u8]) -> Result<usize> {
        self.get_stream_ref(i)?.read(b)
    }
    pub fn write_stream(&self, i: usize, b: &[u8]) -> Result<usize> {
        self.get_stream_ref(i)?.write(b)
    }
    fn get_listener_ref(&self, i: usize) -> Result<&mio::net::TcpListener> {
        match match self.slab.get(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Listener(listener) => Some(listener),
                _ => None,
            },
            None => None,
        } {
            Some(ntcp) => Ok(ntcp),
            None => Err(Error::new(ErrorKind::Other, "Listener not found for id")),
        }
    }
    fn get_stream_ref(&self, i: usize) -> Result<&mio::net::TcpStream> {
        match match self.slab.get(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Stream(s) => Some(s),
                _ => None,
            },
            None => None,
        } {
            Some(ntcp) => Ok(ntcp),
            None => Err(Error::new(ErrorKind::Other, "Stream not found for id")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn listen_connect_read_write() {
        let mut nl = NetLoop::new();
        let listener = nl.tcp_listen(&"127.0.0.1:34254".parse().unwrap()).unwrap();
        let conn = nl.tcp_connect(&"127.0.0.1:34254".parse().unwrap()).unwrap();

        let to_write = [0, 1, 2, 3, 4, 5, 6, 7, 8];
        loop {
            let event = nl.event_receiver.recv().unwrap();
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
        }
    }
}
