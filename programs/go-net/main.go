package main

import (
	"fmt"
	"net/http"

	wnet "github.com/maxmcd/wasabi/pkg/net"
)

func main() {
	tcpDial()
	// httpRequest()
	tcpHTTPServer()

}

func tcpDial() {
	fmt.Println(wnet.Dial("tcp", "127.0.0.1:80"))
}

func httpRequest() {
	client := http.Client{Transport: &wnet.RoundTripper{}}

	req, err := http.NewRequest("GET", "http://www.google.com/", nil)
	if err != nil {
		panic(err)
	}
	resp, err := client.Do(req)
	fmt.Println("Request response:", resp, err)
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
	_, err := wnet.ListenTcp("128.0.0:8080")
	if err == nil {
		panic("should have errored with invalid ip")
	}
	if err.Error() != "invalid IP address syntax" {
		panic("incorrect error message")
	}
	l, err := wnet.ListenTcp("127.0.0.1:8482")
	if err != nil {
		panic(err)
	}
	fmt.Println("listening")
	for {
		c, err := l.Accept()
		if err != nil {
			panic(err)
		}
		b := make([]byte, 10)
		if _, err := c.Read(b); err != nil {
			panic(err)
		} // crappy little http server
		if _, err := c.Write([]byte(`HTTP/1.1 200 OK
Content-Length: 6
Content-Type: text/plain

wasabi`)); err != nil {
			panic(err)
		}
	}
}
