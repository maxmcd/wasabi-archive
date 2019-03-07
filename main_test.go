package wasabi

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"runtime"
	"sync"
	"testing"
	"time"
)

func TestTimeouts(t *testing.T) {
	// fmt.Println(time.Now())
	println("TestTimeouts")
	println(fmt.Sprintf("%v", time.Now().UnixNano()))
	t0 := time.Now()
	times := []time.Duration{9, 1, 8, 2, 7, 3, 6, 4, 5}
	resultChan := make(chan time.Duration, len(times))
	for _, amount := range times {
		go func(amount time.Duration) {
			println(fmt.Sprintf("Scheduling %d %v", amount, time.Now().Sub(t0)))
			time.Sleep(amount * (time.Millisecond * 1))
			resultChan <- amount
		}(amount)
	}

	for i := 0; i < len(times); i++ {
		out := <-resultChan
		println(fmt.Sprintf("Time %d took %v", out, time.Now().Sub(t0)))
	}
	println("finished TestTimeouts")
}

func TestDialAndHostAndConnect(t *testing.T) {
	println("TestDialAndHostAndConnect")
	l, err := Listen("tcp", "127.0.0.1:8482")
	if err != nil {
		t.Error(err)
	}
	c, err := Dial("tcp", "127.0.0.1:8482")
	if err != nil {
		t.Error(err)
	}
	lc, err := l.Accept()
	if err != nil {
		t.Error(err)
	}

	if c.LocalAddr().String() != lc.RemoteAddr().String() {
		t.Error("Should match")
	}
	if lc.LocalAddr().String() != c.RemoteAddr().String() {
		t.Error("Should match")
	}
	ping := []byte(`ping`)
	if _, err := c.Write([]byte(`ping`)); err != nil {
		t.Error(err)
	}

	b := make([]byte, 4096)
	ln, err := lc.Read(b)
	if err != nil {
		t.Error(err)
	}
	if ln != 4 {
		t.Error("incorrect number of bytes read")
	}
	if !bytes.Equal(b[:ln], ping) {
		t.Error("message not recieved")
	}

	if err := c.Close(); err != nil {
		t.Error(err)
	}
	if err := lc.Close(); err != nil {
		// we currently error here, as the other connection is closed
		// should we do this? What does Go do?
		fmt.Println(err)
	}

	if err := l.Close(); err != nil {
		t.Error(err)
	}
	println("finished TestDialAndHostAndConnect")
}

func TestRoundtripperAndListenAndServe(t *testing.T) {
	println("TestRoundtripperAndListenAndServe")
	body := []byte("Hello World")
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write(body)
	})
	go ListenAndServe("127.0.0.1:40444", handler)
	time.Sleep(time.Millisecond * 10) // wait for the server to be ready

	client := http.Client{Transport: &RoundTripper{}}

	req, err := http.NewRequest("GET", "http://localhost:40444", nil)
	if err != nil {
		t.Error(err)
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Error(err)
	}

	if http.StatusOK != resp.StatusCode {
		t.Error("status code should be 200")
	}

	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		t.Error(err)
	}
	if !bytes.Equal(body, b) {
		t.Error("response body should be the same")
	}
	println("finished TestRoundtripperAndListenAndServe")
}

func TestLookupIP(t *testing.T) {
	println("TestLookupIP")
	ips, err := LookupIP("localhost")
	if err != nil {
		t.Error(err)
	}
	for _, ip := range ips {
		// only check ipv4
		if len(ip) == 4 && (!net.IP{127, 0, 0, 1}.Equal(ip)) {
			t.Error("should be local host")
		}
	}
	println("finished TestLookupIP")
}

func TestCloseRead(t *testing.T) {
	println("TestCloseRead")
	network := "tcp"
	ln, err := newLocalListener(network)
	if err != nil {
		t.Fatal(err)
	}
	defer ln.Close()
	c, err := Dial(ln.Addr().Network(), ln.Addr().String())
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	switch c := c.(type) {
	case *TCPConn:
		err = c.CloseRead()
	}
	if err != nil {
		// TODO: maybe support this. would further move the needle on
		// parsing network error messages
		// if perr := parseCloseError(err, true); perr != nil {
		//  t.Error(perr)
		// }
		t.Fatal(err)
	}
	var b [1]byte
	n, err := c.Read(b[:])
	if n != 0 || err == nil {
		t.Fatalf("got (%d, %v); want (0, error)", n, err)
	}
	println("finished TestCloseRead")
}

func TestCloseWrite(t *testing.T) {
	println("TestCloseWrite")
	handler := func(ls *localServer, ln net.Listener) {
		c, err := ln.Accept()
		if err != nil {
			t.Error(err)
			return
		}
		defer c.Close()

		var b [1]byte
		n, err := c.Read(b[:])
		if n != 0 || err != io.EOF {
			t.Errorf("got (%d, %v); want (0, io.EOF)", n, err)
			return
		}
		switch c := c.(type) {
		case *TCPConn:
			err = c.CloseWrite()
		}
		if err != nil {
			// if perr := parseCloseError(err, true); perr != nil {
			// 	t.Error(perr)
			// }
			t.Error(err)
			return
		}
		n, err = c.Write(b[:])
		if err == nil {
			t.Errorf("got (%d, %v); want (any, error)", n, err)
			return
		}
	}
	network := "tcp"

	ls, err := newLocalServer(network)
	if err != nil {
		t.Fatal(err)
	}
	defer ls.teardown()
	if err := ls.buildup(handler); err != nil {
		t.Fatal(err)
	}

	c, err := Dial(ls.Listener.Addr().Network(), ls.Listener.Addr().String())
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()

	switch c := c.(type) {
	case *TCPConn:
		err = c.CloseWrite()
	}
	if err != nil {
		// if perr := parseCloseError(err, true); perr != nil {
		//     t.Error(perr)
		// }
		t.Fatal(err)
	}
	var b [1]byte
	n, err := c.Read(b[:])
	if n != 0 || err != io.EOF {
		t.Fatalf("got (%d, %v); want (0, io.EOF)", n, err)
	}
	n, err = c.Write(b[:])
	if err == nil {
		t.Fatalf("got (%d, %v); want (any, error)", n, err)
	}
	println("finished TestCloseWrite")
}

func TestListenerClose(t *testing.T) {
	println("TestListenerClose")
	network := "tcp"

	ln, err := newLocalListener(network)
	if err != nil {
		t.Fatal(err)
	}
	switch network {
	case "unix", "unixpacket":
		defer os.Remove(ln.Addr().String())
	}

	dst := ln.Addr().String()
	if err := ln.Close(); err != nil {
		// if perr := parseCloseError(err, false); perr != nil {
		// 	t.Error(perr)
		// }
		t.Fatal(err)
	}
	c, err := ln.Accept()
	if err == nil {
		c.Close()
		t.Fatal("should fail")
	}

	if network == "tcp" {
		// We will have two TCP FSMs inside the
		// kernel here. There's no guarantee that a
		// signal comes from the far end FSM will be
		// delivered immediately to the near end FSM,
		// especially on the platforms that allow
		// multiple consumer threads to pull pending
		// established connections at the same time by
		// enabling SO_REUSEPORT option such as Linux,
		// DragonFly BSD. So we need to give some time
		// quantum to the kernel.
		//
		// Note that net.inet.tcp.reuseport_ext=1 by
		// default on DragonFly BSD.
		time.Sleep(time.Millisecond)

		cc, err := Dial("tcp", dst)
		if err == nil {
			t.Error("Dial to closed TCP listener succeeded.")
			cc.Close()
		}
	}
	println("finished TestListenerClose")
}

// Issue 24808: verify that ECONNRESET is not temporary for read.
func TestNotTemporaryRead(t *testing.T) {
	println("TestNotTemporaryRead")
	server := func(cs *TCPConn) error {
		cs.SetLinger(0)
		// Give the client time to get stuck in a Read.
		time.Sleep(20 * time.Millisecond)
		cs.Close()
		return nil
	}
	client := func(ss *TCPConn) error {
		_, err := ss.Read([]byte{0})
		if err == nil {
			return errors.New("Read succeeded unexpectedly")
		} else if err == io.EOF {
			// This happens on NaCl and Plan 9.
			return nil
		} else if ne, ok := err.(net.Error); !ok {
			return fmt.Errorf("unexpected error %v", err)
		} else if ne.Temporary() {
			return fmt.Errorf("unexpected temporary error %v", err)
		}
		return nil
	}
	withTCPConnPair(t, client, server)
	println("finished TestNotTemporaryRead")
}

// Issue 17695: verify that a blocked Read is woken up by a Close.
func TestCloseUnblocksRead(t *testing.T) {
	println("TestCloseUnblocksRead")
	server := func(cs *TCPConn) error {
		// Give the client time to get stuck in a Read:
		time.Sleep(20 * time.Millisecond)
		cs.Close()
		return nil
	}
	client := func(ss *TCPConn) error {
		n, err := ss.Read([]byte{0})
		if n != 0 || err != io.EOF {
			return fmt.Errorf("Read = %v, %v; want 0, EOF", n, err)
		}
		return nil
	}
	withTCPConnPair(t, client, server)
	println("finished TestCloseUnblocksRead")
}

// Tests that a blocked Read is interrupted by a concurrent SetReadDeadline
// modifying that Conn's read deadline to the past.
// See golang.org/cl/30164 which documented this. The net/http package
// depends on this.
func TestReadTimeoutUnblocksRead(t *testing.T) {
	println("TestReadTimeoutUnblocksRead")
	serverDone := make(chan struct{})
	server := func(cs *TCPConn) error {
		defer close(serverDone)
		errc := make(chan error, 1)
		go func() {
			defer close(errc)
			go func() {
				// TODO: find a better way to wait
				// until we're blocked in the cs.Read
				// call below. Sleep is lame.
				time.Sleep(100 * time.Millisecond)

				// Interrupt the upcoming Read, unblocking it:
				cs.SetReadDeadline(time.Unix(123, 0)) // time in the past
			}()
			var buf [1]byte
			n, err := cs.Read(buf[:1])
			if n != 0 || err == nil {
				errc <- fmt.Errorf("Read = %v, %v; want 0, non-nil", n, err)
			}
		}()
		select {
		case err := <-errc:
			return err
		case <-time.After(5 * time.Second):
			buf := make([]byte, 2<<20)
			buf = buf[:runtime.Stack(buf, true)]
			// println("Stacks at timeout:\n", string(buf))
			return errors.New("timeout waiting for Read to finish")
		}

	}
	// Do nothing in the client. Never write. Just wait for the
	// server's half to be done.
	client := func(*TCPConn) error {
		<-serverDone
		return nil
	}
	withTCPConnPair(t, client, server)
	println("finished TestReadTimeoutUnblocksRead")
}

func TestZeroByteRead(t *testing.T) {
	println("TestZeroByteRead")
	network := "tcp"

	ln, err := newLocalListener(network)
	if err != nil {
		t.Fatal(err)
	}
	connc := make(chan net.Conn, 1)
	go func() {
		defer ln.Close()
		c, err := ln.Accept()
		if err != nil {
			t.Error(err)
		}
		connc <- c // might be nil
	}()
	c, err := Dial(network, ln.Addr().String())
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	sc := <-connc
	if sc == nil {
		return
	}
	defer sc.Close()
	n, err := c.Read(nil)
	if n != 0 || err != nil {
		t.Errorf("%s: zero byte client read = %v, %v; want 0, nil", network, n, err)
	}
	n, err = sc.Read(nil)
	if n != 0 || err != nil {
		t.Errorf("%s: zero byte server read = %v, %v; want 0, nil", network, n, err)
	}
	println("finished TestZeroByteRead")
}

// withTCPConnPair sets up a TCP connection between two peers, then
// runs peer1 and peer2 concurrently. withTCPConnPair returns when
// both have completed.
func withTCPConnPair(t *testing.T, peer1, peer2 func(c *TCPConn) error) {
	ln, err := newLocalListener("tcp")
	if err != nil {
		t.Fatal(err)
	}
	defer ln.Close()
	errc := make(chan error, 2)
	go func() {
		c1, err := ln.Accept()
		if err != nil {
			errc <- err
			return
		}
		defer c1.Close()
		errc <- peer1(c1.(*TCPConn))
	}()
	go func() {
		c2, err := Dial("tcp", ln.Addr().String())
		if err != nil {
			errc <- err
			return
		}
		defer c2.Close()
		errc <- peer2(c2.(*TCPConn))
	}()
	for i := 0; i < 2; i++ {
		if err := <-errc; err != nil {
			t.Fatal(err)
		}
	}
}

func newLocalListener(network string) (net.Listener, error) {
	switch network {
	case "tcp":
		return ListenTCP("tcp", &net.TCPAddr{IP: net.IP{127, 0, 0, 1}, Port: 0})
	}
	return nil, fmt.Errorf("%s is not supported", network)
}

type localServer struct {
	lnmu sync.RWMutex
	net.Listener
	done chan bool // signal that indicates server stopped
}

func (ls *localServer) buildup(handler func(*localServer, net.Listener)) error {
	go func() {
		handler(ls, ls.Listener)
		close(ls.done)
	}()
	return nil
}

func (ls *localServer) teardown() error {
	ls.lnmu.Lock()
	if ls.Listener != nil {
		network := ls.Listener.Addr().Network()
		address := ls.Listener.Addr().String()
		ls.Listener.Close()
		<-ls.done
		ls.Listener = nil
		switch network {
		case "unix", "unixpacket":
			os.Remove(address)
		}
	}
	ls.lnmu.Unlock()
	return nil
}

func newLocalServer(network string) (*localServer, error) {
	ln, err := newLocalListener(network)
	if err != nil {
		return nil, err
	}
	return &localServer{Listener: ln, done: make(chan bool)}, nil
}

// someTimeout is used just to test that net.Conn implementations
// don't explode when their SetFooDeadline methods are called.
// It isn't actually used for testing timeouts.
const someTimeout = 10 * time.Second

func TestConnAndListener(t *testing.T) {
	println("TestConnAndListener")
	network := "tcp"

	ls, err := newLocalServer(network)
	if err != nil {
		t.Fatal(err)
	}
	defer ls.teardown()
	ch := make(chan error, 1)
	handler := func(ls *localServer, ln net.Listener) { transponder(ln, ch) }
	if err := ls.buildup(handler); err != nil {
		t.Fatal(err)
	}
	if ls.Listener.Addr().Network() != network {
		t.Fatalf("got %s; want %s", ls.Listener.Addr().Network(), network)
	}

	c, err := Dial(ls.Listener.Addr().Network(), ls.Listener.Addr().String())
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	if c.LocalAddr().Network() != network || c.RemoteAddr().Network() != network {
		t.Fatalf("got %s->%s; want %s->%s", c.LocalAddr().Network(), c.RemoteAddr().Network(), network, network)
	}
	c.SetDeadline(time.Now().Add(someTimeout))
	c.SetReadDeadline(time.Now().Add(someTimeout))
	c.SetWriteDeadline(time.Now().Add(someTimeout))

	if _, err := c.Write([]byte("CONN AND LISTENER TEST")); err != nil {
		t.Fatal(err)
	}
	rb := make([]byte, 128)
	if _, err := c.Read(rb); err != nil {
		t.Fatal(err)
	}

	for err := range ch {
		t.Errorf("#: %v", err)
	}
	println("finished TestConnAndListener")
}

func transponder(ln net.Listener, ch chan<- error) {
	defer close(ch)

	switch ln := ln.(type) {
	case *TCPListener:
		ln.SetDeadline(time.Now().Add(someTimeout))
	}
	c, err := ln.Accept()
	if err != nil {
		ch <- err
		return
	}
	defer c.Close()

	network := ln.Addr().Network()
	if c.LocalAddr().Network() != network || c.RemoteAddr().Network() != network {
		ch <- fmt.Errorf("got %v->%v; expected %v->%v", c.LocalAddr().Network(), c.RemoteAddr().Network(), network, network)
		return
	}
	c.SetDeadline(time.Now().Add(someTimeout))
	c.SetReadDeadline(time.Now().Add(someTimeout))
	c.SetWriteDeadline(time.Now().Add(someTimeout))

	b := make([]byte, 256)
	n, err := c.Read(b)
	if err != nil {
		ch <- err
		return
	}
	if _, err := c.Write(b[:n]); err != nil {
		ch <- err
		return
	}
}
