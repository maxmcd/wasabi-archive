package wasabi

import (
	"io"
	"net"
	"net/http"
	"os"
	"syscall"
	"time"

	wnet "github.com/maxmcd/wasabi/internal/net"
)

// TCPConn ...
type TCPConn struct {
	tc wnet.TCPConn
}

func (c TCPConn) Read(b []byte) (ln int, err error) {
	return c.tc.Read(b)
}
func (c TCPConn) Write(b []byte) (ln int, err error) {
	return c.tc.Write(b)
}
func (c TCPConn) Close() error {
	return c.tc.Close()
}
func (c TCPConn) LocalAddr() net.Addr {
	return c.tc.LocalAddr()
}
func (c TCPConn) RemoteAddr() net.Addr {
	return c.tc.RemoteAddr()
}
func (c TCPConn) SetDeadline(t time.Time) error {
	return c.tc.SetDeadline(t)
}
func (c TCPConn) SetReadDeadline(t time.Time) error {
	return c.tc.SetReadDeadline(t)
}
func (c TCPConn) SetWriteDeadline(t time.Time) error {
	return c.tc.SetWriteDeadline(t)
}
func (c TCPConn) CloseRead() error {
	return c.tc.CloseRead()
}
func (c TCPConn) CloseWrite() error {
	return c.tc.CloseWrite()
}
func (c TCPConn) File() (f *os.File, err error) {
	return c.tc.File()
}
func (c TCPConn) ReadFrom(r io.Reader) (int64, error) {
	return c.tc.ReadFrom(r)
}
func (c TCPConn) SetKeepAlive(keepalive bool) error {
	return c.tc.SetKeepAlive(keepalive)
}
func (c TCPConn) SetKeepAlivePeriod(d time.Duration) error {
	return c.tc.SetKeepAlivePeriod(d)
}
func (c TCPConn) SetLinger(sec int) error {
	return c.tc.SetLinger(sec)
}
func (c TCPConn) SetNoDelay(noDelay bool) error {
	return c.tc.SetNoDelay(noDelay)
}
func (c TCPConn) SetReadBuffer(bytes int) error {
	return c.tc.SetReadBuffer(bytes)
}
func (c TCPConn) SetWriteBuffer(bytes int) error {
	return c.tc.SetWriteBuffer(bytes)
}
func (c TCPConn) SyscallConn() (syscall.RawConn, error) {
	return c.tc.SyscallConn()
}

// TCPListener ...
type TCPListener struct {
	tl wnet.TCPListener
}

func (l *TCPListener) Close() error {
	return l.tl.Close()
}

func (l *TCPListener) Addr() net.Addr {
	return l.tl.Addr()
}

func (l *TCPListener) Accept() (net.Conn, error) {
	return l.tl.Accept()
}
func (l *TCPListener) AcceptTCP() (net.Conn, error) {
	return l.tl.AcceptTCP()
}

// ListenTCP ...
func ListenTCP(addr string) (TCPListener, error) {
	l, err := wnet.ListenTCP(addr)
	return TCPListener{tl: l}, err
}

// Dial ...
func Dial(network, addr string) (c net.Conn, err error) {
	return wnet.Dial(network, addr)
}

// ListenAndServe ...
func ListenAndServe(addr string, handler http.Handler) error {
	return wnet.ListenAndServe(addr, handler)
}

// LookupIPAddr ...
func LookupIPAddr(host string) (addrs []net.IPAddr, err error) {
	return wnet.LookupIPAddr(host)
}

//RoundTripper ...
type RoundTripper struct {
	ReadTimeout    time.Duration
	RequestTimeout time.Duration
	rt             *wnet.RoundTripper
}

// RoundTrip ...
func (rt *RoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	if rt.rt == nil {
		rt.rt = &wnet.RoundTripper{}
	}
	rt.rt.ReadTimeout = rt.ReadTimeout
	rt.rt.RequestTimeout = rt.RequestTimeout
	return rt.rt.RoundTrip(req)
}
