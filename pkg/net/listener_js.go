// +build js,wasm
package net

import (
	"errors"
	"fmt"
	"net"
	"syscall/js"

	"github.com/maxmcd/wasabi/pkg/wasm"
)

type event struct {
	readable  bool
	writeable bool
}

// type eventState struct {
// 	readable  bool
// 	writeable bool
// 	readChan  (chan bool)
// 	writeChan (chan bool)
// }

var connections map[int32](chan event)

func init() {
	connections = make(map[int32](chan event))
	callback := js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		println("called callback")
		for i, _ := range args {
			if i%2 != 0 {
				continue
			}
			print("foo")
			token := args[i].Int()
			println(token + 10000)
			state := args[i+1].Int()
			readable := ((state >> 0) & 1) == 1
			writeable := ((state >> 1) & 1) == 1
			select {
			case connections[int32(token)] <- event{readable, writeable}:
			default:
				println("no callback message sent")
			}
		}
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

func acceptTcp(id int32) int32

func (l *Listener) Accept() (Conn, error) {
	event := <-connections[l.token]
	_ = event
	token := acceptTcp(l.token)
	fmt.Println("accept token", token)
	return Conn{token: int32(token)}, nil
}

type Conn struct {
	token int32
}

func readConn(id int32, b []byte) (int32, bool)

func (c *Conn) Read(b []byte) (int, error) {
	ln, ok := readConn(c.token, b)
	if ok {
		return int(ln), nil
	}
	bytes, _ := wasm.GetBytes(ln) // ln is ref if there's an error
	err := errors.New(string(bytes))
	return 0, err
}

func writeConn(id int32, b []byte) (int32, bool)

func (c *Conn) Write(b []byte) (int, error) {
	ln, ok := writeConn(c.token, b)
	if ok {
		return int(ln), nil
	}
	bytes, _ := wasm.GetBytes(ln) // ln is ref if there's an error
	err := errors.New(string(bytes))
	return 0, err
}

func listenTcp(addr string) (int32, bool)

func ListenTcp(addr string) (Listener, error) {
	id, ok := listenTcp(addr)
	if ok {
		connections[id] = make(chan event)
		fmt.Printf("%#v\n", connections)
		return Listener{token: id}, nil
	}
	bytes, _ := wasm.GetBytes(id) // id is ref if there's an error
	err := errors.New(string(bytes))
	return Listener{token: -1}, err

}

func lookupIPAddr(host string) (int32, bool)

// LookupIPAddr looks up host using the local resolver. It returns a slice of
// that host's IPv4 addresses.
func LookupIPAddr(host string) (addrs []net.IPAddr, err error) {
	ref, ok := lookupIPAddr(host)
	if !ok {
		bytes, _ := wasm.GetBytes(ref)
		err = errors.New(string(bytes))
		return
	}
	refs, err := wasm.GetArrayOfRefs(ref)
	if err != nil {
		return
	}
	addrs = make([]net.IPAddr, len(refs))
	for i, ref := range refs {
		val, err := wasm.GetBytes(ref)
		if err != nil {
			return nil, err
		}
		addrs[i] = net.IPAddr{IP: val}
	}
	return
}
