package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/maxmcd/wasabi"
)

func main() {
	// listenAndServe()
	// dialAndHostAndConnect()
	// tcpDial()
	httpRequest("http://www.google.com/")
	tcpHTTPServer()
	// serverListen()
}

func tcpDial() {
	fmt.Println(wasabi.Dial("tcp", "127.0.0.1:80"))
}

func httpRequest(url string) {
	client := http.Client{Transport: &wasabi.RoundTripper{}}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		panic(err)
	}
	resp, err := client.Do(req)
	fmt.Println("Request response:", resp, err)
}

func lookupIPAddr() {
	addrs, err := wasabi.LookupIPAddr("www")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(addrs)

	addrs, err = wasabi.LookupIPAddr("www.google.com")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(addrs)
}

func dialAndHostAndConnect() {
	l, err := wasabi.ListenTCP("127.0.0.1:8482")
	if err != nil {
		panic(err)
	}
	c, err := wasabi.Dial("tcp", "127.0.0.1:8482")
	if err != nil {
		panic(err)
	}
	lc, err := l.Accept()
	if err != nil {
		panic(err)
	}

	if c.LocalAddr().String() != lc.RemoteAddr().String() {
		panic("Should match")
	}
	if lc.LocalAddr().String() != c.RemoteAddr().String() {
		panic("Should match")
	}
	ping := []byte(`ping`)
	if _, err := c.Write([]byte(`ping`)); err != nil {
		panic(err)
	}

	b := make([]byte, 4096)
	ln, err := lc.Read(b)
	if err != nil {
		panic(err)
	}
	if ln != 4 {
		panic("incorrect number of bytes read")
	}
	if !bytes.Equal(b[:ln], ping) {
		panic("message not recieved")
	}

	if err := c.Close(); err != nil {
		panic(err)
	}
	if err := lc.Close(); err != nil {
		// we currently error here, as the other connection is closed
		// should we do this? What does Go do?
		fmt.Println(err)
	}

	if err := l.Close(); err != nil {
		panic(err)
	}

}

func tcpHTTPServer() {
	_, err := wasabi.ListenTCP("128.0.0:8080")
	if err == nil {
		panic("should have errored with invalid ip")
	}
	if err.Error() != "invalid IP address syntax" {
		panic("incorrect error message")
	}
	l, err := wasabi.ListenTCP("127.0.0.1:8482")
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
		// if err := c.Close(); err != nil {
		// 	panic(err)
		// }
	}
}

func listenAndServe() {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("%s %s %s\n", r.Method, r.URL.String(), time.Now())
		w.Write([]byte("Hello World"))
	})
	fmt.Println("listening on :8080")
	wasabi.ListenAndServe("127.0.0.1:8080", handler)
}

func serverListen() {
	go func() {
		start := time.Now()
		for i := 0; i < 1000; i++ {
			httpRequest("http://localhost:8080/")
		}
		fmt.Println(time.Now().Sub(start) / 1000)
	}()

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("%s %s %s\n", r.Method, r.URL.String(), time.Now())
		w.Write([]byte("Hello World"))
	})
	fmt.Println("listening on :8080")
	log.Fatal(wasabi.ListenAndServe("127.0.0.1:8080", handler))
}
