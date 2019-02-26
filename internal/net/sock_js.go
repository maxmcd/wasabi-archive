// +build js,wasm
package net

import (
	"errors"
	"io"
	"net"
	"net/http"
	"os"
	"strings"
	"sync"
	"syscall"
	"syscall/js"
	"time"

	"github.com/maxmcd/wasabi/internal/wasm"
)

type eventState struct {
	state int
	cond  *sync.Cond
}

func (e *eventState) readable() bool {
	return ((e.state >> 0) & 1) == 1
}
func (e *eventState) writeable() bool {
	return ((e.state >> 1) & 1) == 1
}
func (e *eventState) hup() bool {
	return ((e.state >> 2) & 1) == 1
}
func (e *eventState) error() bool {
	return ((e.state >> 3) & 1) == 1
}

func (e *eventState) dead() bool {
	return e.error() || e.hup()
}

func (e *eventState) writewait() error {
	if e.writeable() {
		return nil
	}
	e.cond.L.Lock()
	for {
		if e.dead() {
			return errors.New("wasabi: Connection closed")
		}
		if e.writeable() {
			e.state = e.state ^ (1 << 1)
			break
		}
		e.cond.Wait()
	}
	e.cond.L.Unlock()
	return nil
}

func (e *eventState) readwait() error {
	e.cond.L.Lock()
	for {
		if e.dead() {
			return errors.New("wasabi: Connection closed")
		}
		if e.readable() {
			e.state = e.state ^ (1 << 0)
			break
		}
		e.cond.Wait()
	}
	e.cond.L.Unlock()
	return nil
}

func newEventState() *eventState {
	return &eventState{
		state: 0,
		cond:  sync.NewCond(&sync.Mutex{}),
	}
}

var connections map[int32]*eventState

func init() {
	connections = make(map[int32]*eventState)
	callback := js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		for i, _ := range args {
			if i%2 != 0 {
				continue
			}
			token := args[i].Int()
			es := connections[int32(token)]
			es.state = args[i+1].Int()
			es.cond.Broadcast()
		}
		return nil
	})
	nlr := js.Global().Get("net_listener").New()
	nlr.Call("register", callback)
}

type TCPListener struct {
	token int32
}

func acceptTcp(id int32) (int32, bool)

func (l *TCPListener) accept() (c TCPConn, err error) {
	for {
		token, ok := acceptTcp(l.token)
		if ok {
			connections[token] = newEventState()
			c.token = int32(token)
			return c, nil
		}
		bytes, _ := wasm.GetBytes(token)
		err = errors.New(string(bytes))
		if !strings.Contains(err.Error(), "Resource temporarily unavailable (os error") {
			return
		}
		if err = connections[l.token].readwait(); err != nil {
			return c, err
		}
	}
	return
}

func (l *TCPListener) Accept() (net.Conn, error) {
	c, err := l.accept()
	return c, err
}

func (l *TCPListener) AcceptTCP() (TCPConn, error) {
	c, err := l.accept()
	return c, err
}

func closeListener(id int32) (int32, bool)

func (l *TCPListener) Close() error {
	ref, ok := closeListener(l.token)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}

func (l *TCPListener) Addr() net.Addr {
	// TODO: implement
	return &net.TCPAddr{
		IP:   net.IPv4(127, 0, 0, 1),
		Port: 8668,
		Zone: "",
	}
}

type TCPConn struct {
	token int32
}

func readConn(id int32, b []byte) (int32, bool)

func (c TCPConn) Read(b []byte) (ln int, err error) {
	for {
		length, ok := readConn(c.token, b)
		if ok {
			return int(length), nil
		}
		bytes, _ := wasm.GetBytes(length) // ln is ref if there's an error
		err = errors.New(string(bytes))
		if !strings.Contains(err.Error(), "Resource temporarily unavailable (os error") {
			return 0, err
		}
		if err := connections[c.token].readwait(); err != nil {
			return 0, err
		}
	}
	return
}

func writeConn(id int32, b []byte) (int32, bool)

func (c TCPConn) Write(b []byte) (ln int, err error) {
	for {
		length, ok := writeConn(c.token, b)
		if ok {
			return int(length), nil
		}
		bytes, _ := wasm.GetBytes(length) // ln is ref if there's an error
		err = errors.New(string(bytes))
		if err.Error() != "Resource temporarily unavailable (os error 35)" {
			return 0, err
		}
		if err := connections[c.token].writewait(); err != nil {
			return 0, err
		}
	}
}

func closeConn(id int32) (int32, bool)

func (c TCPConn) Close() error {
	ref, ok := closeConn(c.token)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}

func localAddr(id int32, b []byte)

func (c TCPConn) LocalAddr() net.Addr {
	b := make([]byte, 6)
	localAddr(c.token, b)
	return &net.TCPAddr{
		IP:   net.IPv4(b[0], b[1], b[2], b[3]),
		Port: int(uint16(b[4]) | uint16(b[5])<<8),
		Zone: "",
	}
}

func remoteAddr(id int32, b []byte)

func (c TCPConn) RemoteAddr() net.Addr {
	b := make([]byte, 6)
	remoteAddr(c.token, b)
	return &net.TCPAddr{
		IP:   net.IPv4(b[0], b[1], b[2], b[3]),
		Port: int(uint16(b[4]) | uint16(b[5])<<8),
		Zone: "",
	}
}
func (c TCPConn) SetDeadline(t time.Time) error {
	return nil
}
func (c TCPConn) SetReadDeadline(t time.Time) error {
	return nil
}
func (c TCPConn) SetWriteDeadline(t time.Time) error {
	return nil
}

func (c TCPConn) CloseRead() error {
	return nil
}
func (c TCPConn) CloseWrite() error {
	return nil
}
func (c TCPConn) File() (f *os.File, err error) {
	return nil, nil
}
func (c TCPConn) ReadFrom(r io.Reader) (int64, error) {
	return 0, nil
}

func (c TCPConn) SetKeepAlive(keepalive bool) error {
	return nil
}

// SetKeepAlivePeriod sets period between keep alives.
func (c TCPConn) SetKeepAlivePeriod(d time.Duration) error {
	return nil
}

func (c TCPConn) SetLinger(sec int) error {
	return nil
}

func (c TCPConn) SetNoDelay(noDelay bool) error {
	return nil
}

func (c TCPConn) SetReadBuffer(bytes int) error {
	return nil
}

func (c TCPConn) SetWriteBuffer(bytes int) error {
	return nil
}
func (c TCPConn) SyscallConn() (syscall.RawConn, error) {
	return nil, nil
}

func listenTCP(addr string) (int32, bool)

func ListenTCP(addr string) (TCPListener, error) {
	id, ok := listenTCP(addr)
	if ok {
		connections[id] = newEventState()
		return TCPListener{token: id}, nil
	}
	bytes, _ := wasm.GetBytes(id) // id is ref if there's an error
	err := errors.New(string(bytes))
	// TODO: don't just pass a negative number
	return TCPListener{token: -1}, err
}

// func DialContext(ctx context.Context, network, addr string) (net.TCPConn, error) {
// 	var c net.TCPConn
// 	c = &TCPConn{token: -1}
// 	return c, nil
// }

func dialTcp(addr string) (int32, bool)

func Dial(network, addr string) (c net.Conn, err error) {
	if network != "tcp" {
		return c, errors.New("tcp is the only protocal supported")
	}

	host, port, err := net.SplitHostPort(addr)
	if err != nil {
		return
	}
	addrs, err := LookupIPAddr(host)
	if err != nil {
		return
	}
	// this is very simplified. see func (d *Dialer) DialContext in Go src
	ref, ok := dialTcp(addrs[0].String() + ":" + port)
	if ok {
		connections[ref] = newEventState()
		if err := connections[ref].writewait(); err != nil {
			return c, err
		}
		var c net.Conn
		c = &TCPConn{token: ref}
		return c, nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return c, errors.New(string(bytes))
}

type tcpKeepAliveListener struct {
	*TCPListener
}

func (ln tcpKeepAliveListener) Accept() (net.Conn, error) {
	tc, err := ln.AcceptTCP()

	if err != nil {
		return nil, err
	}
	tc.SetKeepAlive(true)
	tc.SetKeepAlivePeriod(3 * time.Minute)
	return tc, nil
}

func ListenAndServe(addr string, handler http.Handler) error {
	server := http.Server{
		Addr:    addr,
		Handler: handler,
	}
	// TODO: allow shorthand address like ":8080"
	if addr == "" {
		addr = ":http"
	}
	ln, err := ListenTCP(addr)
	if err != nil {
		return err
	}
	return server.Serve(tcpKeepAliveListener{&ln})
}
