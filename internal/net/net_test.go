// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package net

import (
	"fmt"
	"io"
	"net"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestLookupIP(t *testing.T) {
	assert := assert.New(t)
	ips, err := LookupIP("localhost")
	if err != nil {
		t.Error(err)
	}
	for _, ip := range ips {
		// only check ipv4
		if len(ip) == 4 {
			assert.Equal(net.IP{127, 0, 0, 1}, ip, "should be local host")
		}
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

func TestCloseRead(t *testing.T) {
	network := "tcp"
	ln, err := newLocalListener(network)
	if err != nil {
		t.Fatal(err)
	}
	defer ln.Close()
	fmt.Println(ln.Addr().String(), ln.Addr().Network())
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
		// 	t.Error(perr)
		// }
		t.Fatal(err)
	}
	var b [1]byte
	n, err := c.Read(b[:])
	if n != 0 || err == nil {
		t.Fatalf("got (%d, %v); want (0, error)", n, err)
	}
}
