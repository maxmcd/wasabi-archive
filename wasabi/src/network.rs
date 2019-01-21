use mio;
use mio::net;
use slab::Slab;
use std::io;
use std::io::{Read, Write};
use std::net::SocketAddr;
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
    event_receiver: mpsc::Receiver<mio::event::Event>,
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
                    event_sender.send(event).unwrap();
                }
            }
        });
        Self {
            slab: Slab::new(),
            poll,
            event_receiver,
        }
    }
    // fn register(&mut self, addr)
    pub fn tcp_listen(&mut self, addr: &SocketAddr) -> io::Result<usize> {
        let listener = net::TcpListener::bind(addr)?;
        let id = self.slab.insert(NetTcp::Listener(listener));
        self.poll.register(
            self.get_listener_ref(id).unwrap(),
            mio::Token(id),
            mio::Ready::readable() | mio::Ready::writable(),
            mio::PollOpt::edge(),
        )?;
        Ok(id)
    }
    pub fn tcp_connect(&mut self, addr: &SocketAddr) -> io::Result<usize> {
        let stream = net::TcpStream::connect(addr)?;
        self.register_stream(stream)
    }
    fn register_stream(&mut self, stream: mio::net::TcpStream) -> io::Result<usize> {
        let id = self.slab.insert(NetTcp::Stream(stream));
        self.poll.register(
            self.get_stream_ref(id).unwrap(),
            mio::Token(id),
            mio::Ready::readable() | mio::Ready::writable(),
            mio::PollOpt::edge(),
        )?;
        Ok(id)
    }
    pub fn tcp_accept(&mut self, id: usize) -> io::Result<usize> {
        let (stream, _) = self.get_listener_ref(id).unwrap().accept()?;
        self.register_stream(stream)
    }
    fn read_stream(&self, i: usize, b: &mut [u8]) -> usize {
        self.get_stream_ref(i).unwrap().read(b).unwrap()
    }
    fn write_stream(&self, i: usize, b: &[u8]) -> usize {
        self.get_stream_ref(i).unwrap().write(b).unwrap()
    }
    fn get_listener_ref(&self, i: usize) -> Option<&mio::net::TcpListener> {
        match self.slab.get(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Listener(listener) => Some(&listener),
                _ => None,
            },
            None => None,
        }
    }
    fn get_stream_ref(&self, i: usize) -> Option<&mio::net::TcpStream> {
        match self.slab.get(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Stream(s) => Some(&s),
                _ => None,
            },
            None => None,
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
                nl.write_stream(event.token().0, &to_write);
            } else if event.token().0 == listener && event.readiness().is_readable() {
                nl.tcp_accept(event.token().0).unwrap();
            } else if event.token().0 == 2 && event.readiness().is_readable() {
                let mut b = [0; 9];
                nl.read_stream(event.token().0, &mut b);
                assert_eq!(b, to_write);
                break;
            // listener connection
            } else {
                continue;
            }
        }
    }
}
