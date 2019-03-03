// +build js,wasm

package net

import (
	"errors"
	"io"
	"net"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
	"syscall"
	"syscall/js"
	"time"

	"github.com/maxmcd/wasabi/internal/wasm"
)

type eventState struct {
	state int
	token int32
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

func getError(id int32) (int32, bool)

func (e *eventState) getError() error {
	ref, found := getError(e.token)
	if found {
		bytes, _ := wasm.GetBytes(ref)
		return errors.New(string(bytes))
	}
	return errors.New("wasabi: Network error")
}

func (e *eventState) dead() bool {
	return e.error() || e.hup()
}

func (e *eventState) wait() {
	e.cond.L.Lock()
	defer e.cond.L.Unlock()
	e.cond.Wait()
}

func (e *eventState) writewait() error {
	if e.writeable() {
		return nil
	}
	e.cond.L.Lock()
	defer e.cond.L.Unlock()
	for {
		if e.error() {
			return e.getError()
		}
		if e.hup() {
			break
		}
		if e.writeable() {
			// remove writeable
			e.state = e.state ^ (1 << 1)
			break
		}
		e.cond.Wait()
	}
	return nil
}

func (e *eventState) readwait() error {
	e.cond.L.Lock()
	defer e.cond.L.Unlock()
	for {
		if e.error() {
			return e.getError()
		}
		if e.hup() {
			break
		}
		if e.readable() {
			// remove readable
			e.state = e.state ^ (1 << 0)
			break
		}
		e.cond.Wait()
	}
	return nil
}

func newEventState(token int32) *eventState {
	return &eventState{
		token: token,
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
	es    *eventState
}

func acceptTcp(id int32) (int32, bool)

func (l TCPListener) accept() (*TCPConn, error) {
	var c TCPConn
	var err error
	for {
		token, ok := acceptTcp(l.token)
		if ok {
			c.es = newEventState(token)
			connections[token] = c.es
			c.token = int32(token)
			return &c, nil
		}
		bytes, _ := wasm.GetBytes(token)
		err = errors.New(string(bytes))
		if !strings.Contains(err.Error(), "Resource temporarily unavailable (os error") {
			return nil, err
		}
		if err = connections[l.token].readwait(); err != nil {
			return nil, err
		}
	}
	return nil, err
}

func (l TCPListener) Accept() (net.Conn, error) {
	c, err := l.accept()
	return c, err
}

func (l TCPListener) AcceptTCP() (*TCPConn, error) {
	c, err := l.accept()
	return c, err
}

func closeListener(id int32) (int32, bool)

func (l TCPListener) Close() error {
	ref, ok := closeListener(l.token)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}

func (l TCPListener) Addr() net.Addr {
	b := make([]byte, 6)
	localAddr(l.token, b)
	return &net.TCPAddr{
		IP:   net.IPv4(b[0], b[1], b[2], b[3]),
		Port: int(uint16(b[4]) | uint16(b[5])<<8),
		Zone: "",
	}
}

type TCPConn struct {
	mu        sync.Mutex
	token     int32
	es        *eventState
	rDeadline time.Time
	wDeadline time.Time
}

func readConn(id int32, b []byte) (int32, bool)

func (c *TCPConn) Read(b []byte) (ln int, err error) {
	for {
		if c.es.error() {
			return 0, c.es.getError()
		}
		length, ok := readConn(c.token, b)
		if ok {
			if length == 0 && len(b) != 0 {
				return 0, io.EOF
			}
			return int(length), nil
		}
		if c.es.hup() {
			return 0, io.EOF
		}
		bytes, _ := wasm.GetBytes(length) // ln is ref if there's an error
		err = errors.New(string(bytes))

		// TODO: if "Network object not found in slab" error then the connection
		// likely existed and was closed.

		if !strings.Contains(err.Error(), "Resource temporarily unavailable (os error") {
			return 0, err
		} else {
			if c.es.readable() {
				// remove readable
				c.es.state = c.es.state ^ (1 << 0)
			}
		}

		if !c.rDeadline.IsZero() {
			d := time.Until(c.rDeadline)
			if d <= 0 {
				return 0, syscall.EAGAIN
			}
			time.AfterFunc(d, c.es.cond.Broadcast)
		}
		if c.es.readable() {
			continue
		}
		c.es.wait()
	}
	return
}

func writeConn(id int32, b []byte) (int32, bool)

func (c *TCPConn) Write(b []byte) (ln int, err error) {
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

func (c *TCPConn) Close() error {
	ref, ok := closeConn(c.token)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}

func localAddr(id int32, b []byte)

func (c *TCPConn) LocalAddr() net.Addr {
	b := make([]byte, 6)
	localAddr(c.token, b)
	return &net.TCPAddr{
		IP:   net.IPv4(b[0], b[1], b[2], b[3]),
		Port: int(uint16(b[4]) | uint16(b[5])<<8),
		Zone: "",
	}
}

func remoteAddr(id int32, b []byte)

func (c *TCPConn) RemoteAddr() net.Addr {
	b := make([]byte, 6)
	remoteAddr(c.token, b)
	return &net.TCPAddr{
		IP:   net.IPv4(b[0], b[1], b[2], b[3]),
		Port: int(uint16(b[4]) | uint16(b[5])<<8),
		Zone: "",
	}
}
func (c *TCPConn) SetDeadline(t time.Time) error {
	return nil
}
func (c *TCPConn) SetReadDeadline(t time.Time) error {
	c.rDeadline = t
	c.es.cond.Broadcast()
	return nil
}
func (c *TCPConn) SetWriteDeadline(t time.Time) error {
	return nil
}

func shutdownConn(id int32, how int32) (int32, bool)

func (c *TCPConn) CloseRead() error {
	ref, ok := shutdownConn(c.token, 1)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}
func (c *TCPConn) CloseWrite() error {
	ref, ok := shutdownConn(c.token, 2)
	if ok {
		return nil
	}
	bytes, _ := wasm.GetBytes(ref)
	return errors.New(string(bytes))
}
func (c *TCPConn) File() (f *os.File, err error) {
	return nil, nil
}
func (c *TCPConn) ReadFrom(r io.Reader) (int64, error) {
	return 0, nil
}

func (c *TCPConn) SetKeepAlive(keepalive bool) error {
	return nil
}

// SetKeepAlivePeriod sets period between keep alives.
func (c *TCPConn) SetKeepAlivePeriod(d time.Duration) error {
	return nil
}

func (c *TCPConn) SetLinger(sec int) error {
	return nil
}

func (c *TCPConn) SetNoDelay(noDelay bool) error {
	return nil
}

func (c *TCPConn) SetReadBuffer(bytes int) error {
	return nil
}

func (c *TCPConn) SetWriteBuffer(bytes int) error {
	return nil
}
func (c *TCPConn) SyscallConn() (syscall.RawConn, error) {
	return nil, nil
}

func listenTCP(addr string) (int32, bool)

func ListenTCP(network string, laddr *net.TCPAddr) (*TCPListener, error) {
	id, ok := listenTCP(laddr.String())
	if ok {
		es := newEventState(id)
		connections[id] = es
		return &TCPListener{token: id, es: es}, nil
	}
	bytes, _ := wasm.GetBytes(id) // id is ref if there's an error
	err := errors.New(string(bytes))
	// TODO: don't just pass a negative number
	return &TCPListener{token: -1}, err
}

func Listen(network, addr string) (net.Listener, error) {
	host, port, err := net.SplitHostPort(addr)
	if err != nil {
		return nil, err
	}
	addrs, err := LookupIP(host)
	if err != nil {
		return nil, err
	}
	iport, err := strconv.Atoi(port)
	if err != nil {
		return nil, err
	}
	return ListenTCP(network, &net.TCPAddr{IP: addrs[0], Port: iport})
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
	addrs, err := LookupIP(host)
	if err != nil {
		return
	}
	// this is very simplified. see func (d *Dialer) DialContext in Go src
	ref, ok := dialTcp(addrs[0].String() + ":" + port)
	if ok {
		es := newEventState(ref)
		connections[ref] = es
		if err := es.writewait(); err != nil {
			return c, err
		}
		var c net.Conn
		c = &TCPConn{token: ref, es: es}
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
	ln, err := Listen("tcp", addr)
	if err != nil {
		return err
	}
	return server.Serve(tcpKeepAliveListener{ln.(*TCPListener)})
}
