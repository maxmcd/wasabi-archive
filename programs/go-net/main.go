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
	l := wnet.ListenTcp("127.0.0.1:8000")
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
