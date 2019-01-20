package net

import (
	"fmt"
	"net"
	"syscall/js"
)

var connections map[int32](chan int)

func init() {
	connections = make(map[int32](chan int))
	callback := js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		connections[int32(0)] <- 1
		// for i, _ := range args {
		// 	if i%2 == 0 {
		// 		continue
		// 	}
		// 	token := args[i].Int()
		// 	new_token := args[i+1].Int()
		// 	connections[int32(token)] <- new_token
		// }
		return nil
	})
	nlr := js.Global().Get("net_listener").New()
	nlr.Call("register", callback)
}

type Resolver struct {
	net.Resolver
}

// func ListenTCP(network string, laddr *net.TCPAddr) (*TCPListener, error) {

// }

type Listener struct {
	token int32
}

func acceptTcp(id int32)

func (l *Listener) Accept() (Conn, error) {
	acceptTcp(l.token)
	token := <-connections[l.token]
	fmt.Println("accept token", token)
	return Conn{token: int32(token)}, nil
}

type Conn struct {
	token int32
}

func readConn(id int32, b []byte) int32

func (c *Conn) Read(b []byte) (int, error) {
	ln := readConn(c.token, b)
	return int(ln), nil
}

func listenTcp(addr string) int32

func ListenTcp(addr string) Listener {
	id := listenTcp(addr)
	connections[id] = make(chan int)
	fmt.Printf("%#v\n", connections)
	return Listener{token: id}
}
