package main

import (
	"fmt"

	wnet "github.com/maxmcd/wasabi/pkg/net"
)

func main() {
	tcpHTTPServer()
}

func lookupIPAddr() {
	addrs, err := wnet.LookupIPAddr("www")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(addrs)

	addrs, err = wnet.LookupIPAddr("www.google.com")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(addrs)
}

func tcpHTTPServer() {
	_, err := wnet.ListenTcp("127.0.0:8000")
	if err == nil {
		panic("should have errored with invalid ip")
	}
	if err.Error() != "invalid IP address syntax" {
		panic("incorrect error message")
	}
	l, err := wnet.ListenTcp("127.0.0.1:8000")
	if err != nil {
		panic(err)
	}
	for {
		c, err := l.Accept()
		if err != nil {
			panic(err)
		}
		b := make([]byte, 10)
		if ln, err := c.Read(b); err != nil {
			panic(err)
		} else {
			fmt.Println(ln, b)
		}
		// crappy little http server
		if ln, err := c.Write([]byte(`HTTP/1.1 200 OK
Content-Length: 6
Content-Type: text/plain

wasabi`)); err != nil {
			panic(err)
		} else {
			fmt.Println(ln)
		}
	}
}
