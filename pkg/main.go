package main

import (
	"context"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"syscall"
	"time"
)

func main() {
	doRequest()
	serverListen()
}

type TCPConn struct {
	c *net.TCPConn
}

func (c *TCPConn) Close() error {
	fmt.Println("tcp conn Close")
	return c.c.Close()
}
func (c *TCPConn) CloseRead() error {
	fmt.Println("tcp conn CloseRead")
	return c.c.CloseRead()
}
func (c *TCPConn) CloseWrite() error {
	fmt.Println("tcp conn CloseWrite")
	return c.c.CloseWrite()
}
func (c *TCPConn) File() (f *os.File, err error) {
	fmt.Println("tcp conn File")
	return c.c.File()
}
func (c *TCPConn) LocalAddr() net.Addr {
	fmt.Println("tcp conn LocalAddr")
	return c.c.LocalAddr()
}
func (c *TCPConn) Read(b []byte) (int, error) {
	i, e := c.c.Read(b)
	fmt.Println("tcp conn Read", len(b), i, e)
	return i, e
}
func (c *TCPConn) ReadFrom(r io.Reader) (int64, error) {
	fmt.Println("tcp conn ReadFrom")
	return c.c.ReadFrom(r)
}
func (c *TCPConn) RemoteAddr() net.Addr {
	fmt.Println("tcp conn RemoteAddr")
	return c.c.RemoteAddr()
}
func (c *TCPConn) SetDeadline(t time.Time) error {
	fmt.Println("tcp conn SetDeadline")
	return c.c.SetDeadline(t)
}

// SetKeepAlive sets whether the operating system should send
// keepalive messages on the connection.
func (c *TCPConn) SetKeepAlive(keepalive bool) error {
	fmt.Println("tcp conn SetKeepAlive")
	return c.c.SetKeepAlive(keepalive)
}

// SetKeepAlivePeriod sets period between keep alives.
func (c *TCPConn) SetKeepAlivePeriod(d time.Duration) error {
	fmt.Println("tcp conn SetKeepAlivePeriod")
	return c.c.SetKeepAlivePeriod(d)
}

func (c *TCPConn) SetLinger(sec int) error {
	fmt.Println("tcp conn SetLinger")
	return c.c.SetLinger(sec)
}

func (c *TCPConn) SetNoDelay(noDelay bool) error {
	fmt.Println("tcp conn SetNoDelay")
	return c.c.SetNoDelay(noDelay)
}

func (c *TCPConn) SetReadBuffer(bytes int) error {
	fmt.Println("tcp conn SetReadBuffer")
	return c.c.SetReadBuffer(bytes)
}

// SetReadDeadline sets the deadline for future Read calls
// and any currently-blocked Read call.
// A zero value for t means Read will not time out.
func (c *TCPConn) SetReadDeadline(t time.Time) error {
	fmt.Println("tcp conn SetReadDeadline", t)
	return c.c.SetReadDeadline(t)
}
func (c *TCPConn) SetWriteBuffer(bytes int) error {
	fmt.Println("tcp conn SetWriteBuffer")
	return c.c.SetWriteBuffer(bytes)
}
func (c *TCPConn) SetWriteDeadline(t time.Time) error {
	fmt.Println("tcp conn SetWriteDeadline")
	return c.c.SetWriteDeadline(t)
}
func (c *TCPConn) SyscallConn() (syscall.RawConn, error) {
	fmt.Println("tcp conn SyscallConn")
	return c.c.SyscallConn()
}
func (c *TCPConn) Write(b []byte) (int, error) {
	fmt.Println("tcp conn Write")
	return c.c.Write(b)
}

type TCPListener struct {
	l *net.TCPListener
}

func (l *TCPListener) Accept() (net.Conn, error) {
	return l.l.Accept()
}
func (l *TCPListener) AcceptTCP() (*net.TCPConn, error) {
	return l.l.AcceptTCP()
}
func (l *TCPListener) Addr() net.Addr {
	return l.l.Addr()
}
func (l *TCPListener) Close() error {
	return l.l.Close()
}

type tcpKeepAliveListener struct {
	*TCPListener
}

func (ln tcpKeepAliveListener) Accept() (net.Conn, error) {
	tc, err := ln.AcceptTCP()

	if err != nil {
		return nil, err
	}
	tcw := TCPConn{c: tc}
	tcw.SetKeepAlive(true)
	tcw.SetKeepAlivePeriod(3 * time.Minute)
	return &tcw, nil
}

func listenAndServe(addr string, handler http.Handler) error {
	server := http.Server{
		Addr:    addr,
		Handler: handler,
	}
	if addr == "" {
		addr = ":http"
	}
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	tcpln := TCPListener{l: ln.(*net.TCPListener)}
	return server.Serve(tcpKeepAliveListener{&tcpln})
}

func serverListen() {
	go func() {
		for {
			time.Sleep(time.Second * 1)
			http.Get("http://localhost:8080")
		}
	}()

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("%s %s %s\n", r.Method, r.URL.String(), time.Now())
		w.Write([]byte("Hello World"))
	})
	fmt.Println("listening on :8080")
	listenAndServe(":8080", handler)
}

func doRequest() {
	transport := http.Transport{
		DialContext:           dialContext,
		MaxIdleConns:          100,
		IdleConnTimeout:       90 * time.Second,
		TLSHandshakeTimeout:   10 * time.Second,
		ExpectContinueTimeout: 1 * time.Second,
	}
	client := http.Client{Transport: &transport}

	req, err := http.NewRequest("GET", "http://www.google.com/", nil)
	if err != nil {
		panic(err)
	}
	resp, err := client.Do(req)
	fmt.Println("Request response:", resp, err)
}

func dialContext(ctx context.Context, network, addr string) (net.Conn, error) {
	dialer := &net.Dialer{
		Timeout:   30 * time.Second,
		KeepAlive: 30 * time.Second,
		DualStack: true,
	}
	fmt.Println("Dialcontext arguments: ", ctx, network, addr)
	conn, err := dialer.DialContext(ctx, network, addr)
	fmt.Printf("Dailer connection: %#v\n", conn)
	return conn, err
}
