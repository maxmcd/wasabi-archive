// +build js,wasm
package net

import (
	"context"
	"fmt"
	"sync"
	"syscall"
)

func (fd *netFD) addrFunc() func(syscall.Sockaddr) Addr {
	fmt.Println("addrfunc")
	switch fd.family {
	case syscall.AF_INET, syscall.AF_INET6:
		switch fd.sotype {
		case syscall.SOCK_STREAM:
			return sockaddrToTCP
		case syscall.SOCK_DGRAM:
			return sockaddrToUDP
		case syscall.SOCK_RAW:
			return sockaddrToIP
		}
	case syscall.AF_UNIX:
		switch fd.sotype {
		case syscall.SOCK_STREAM:
			return sockaddrToUnix
		case syscall.SOCK_DGRAM:
			return sockaddrToUnixgram
		case syscall.SOCK_SEQPACKET:
			return sockaddrToUnixpacket
		}
	}
	return func(syscall.Sockaddr) Addr { return nil }
}

func sysSocket(family, sotype, proto int) (int, error) {
	return 0, syscall.ENOSYS
}

// socket returns a network file descriptor that is ready for
// asynchronous I/O using the network poller.
func socket(ctx context.Context, net string, family, sotype, proto int, ipv6only bool, laddr, raddr sockaddr, ctrlFn func(string, string, syscall.RawConn) error) (*netFD, error) {
	println("net_js/socket")
	fd := &netFD{family: family, sotype: sotype, net: net}

	if laddr != nil && raddr == nil { // listener
		l := laddr.(*TCPAddr)
		fd.laddr = &TCPAddr{
			IP:   l.IP,
			Port: nextPort(),
			Zone: l.Zone,
		}
		fd.listener = true
		fd.incoming = make(chan *netFD, 1024)
		listenersMu.Lock()
		listeners[fd.laddr.(*TCPAddr).String()] = fd
		listenersMu.Unlock()
		return fd, nil
	}

	fd.laddr = &TCPAddr{
		IP:   IPv4(127, 0, 0, 1),
		Port: nextPort(),
	}
	fd.raddr = raddr
	fd.r = newBufferedPipe(65536)
	fd.w = newBufferedPipe(65536)

	fd2 := &netFD{family: fd.family, sotype: sotype, net: net}
	fd2.laddr = fd.raddr
	fd2.raddr = fd.laddr
	fd2.r = fd.w
	fd2.w = fd.r
	listenersMu.Lock()
	l, ok := listeners[fd.raddr.(*TCPAddr).String()]
	if !ok {
		listenersMu.Unlock()
		return nil, syscall.ECONNREFUSED
	}
	l.incoming <- fd2
	listenersMu.Unlock()

	return fd, nil
}

var listenersMu sync.Mutex
var listeners = make(map[string]*netFD)

var portCounterMu sync.Mutex
var portCounter = 0

func nextPort() int {
	portCounterMu.Lock()
	defer portCounterMu.Unlock()
	portCounter++
	return portCounter
}
