package wasabi

import (
	"bytes"
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

func TestDialAndHostAndConnect(t *testing.T) {
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

}

func TestRoundtripperAndListenAndServe(t *testing.T) {
	body := []byte("Hello World")
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write(body)
	})
	go ListenAndServe("127.0.0.1:8080", handler)
	time.Sleep(time.Millisecond * 10) // wait for the server to be ready

	client := http.Client{Transport: &RoundTripper{}}

	req, err := http.NewRequest("GET", "http://localhost:8080", nil)
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
}

func TestLookupIP(t *testing.T) {
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
}

func TestCloseRead(t *testing.T) {
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
}

func TestCloseWrite(t *testing.T) {

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

}

// Issue 17695: verify that a blocked Read is woken up by a Close.
func TestCloseUnblocksRead(t *testing.T) {
	t.Parallel()
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
}

func TestZeroByteRead(t *testing.T) {
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

	if runtime.GOOS == "windows" {
		// A zero byte read on Windows caused a wait for readability first.
		// Rather than change that behavior, satisfy it in this test.
		// See Issue 15735.
		go io.WriteString(sc, "a")
	}

	n, err := c.Read(nil)
	if n != 0 || err != nil {
		t.Errorf("%s: zero byte client read = %v, %v; want 0, nil", network, n, err)
	}

	if runtime.GOOS == "windows" {
		// Same as comment above.
		go io.WriteString(c, "a")
	}
	n, err = sc.Read(nil)
	if n != 0 || err != nil {
		t.Errorf("%s: zero byte server read = %v, %v; want 0, nil", network, n, err)
	}
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
