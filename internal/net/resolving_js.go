// +build js,wasm

package net

import (
	"errors"
	"net"
	"syscall/js"

	"github.com/maxmcd/wasabi/internal/wasm"
)

var jsWasabi = js.Global().Get("wasabi")

func lookupIP(host string) (int32, bool)

// LookupIP looks up host using the local resolver. It returns a slice of
// that host's IPv4 addresses.
func LookupIP(host string) (addrs []net.IP, err error) {
	type callResult struct {
		val js.Value
		err error
	}
	c := make(chan callResult, 1)
	args := []interface{}{js.ValueOf(host)}
	jsWasabi.Call("lookup_ip", append(args, js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		var res callResult

		if jsErr := args[0]; jsErr != js.Null() {
			bytes, _ := wasm.GetBytes(int32(jsErr.Int()))
			res.err = errors.New(string(bytes))
		}

		res.val = js.Undefined()
		if len(args) >= 2 {
			res.val = args[1]
		}

		c <- res
		return nil
	}))...)
	res := <-c

	if res.err != nil {
		err = res.err
		return
	}
	refs, err := wasm.GetArrayOfRefs(int32(res.val.Int()))
	if err != nil {
		return
	}
	addrs = make([]net.IP, len(refs))
	for i, ref := range refs {
		val, err := wasm.GetBytes(ref)
		if err != nil {
			return nil, err
		}
		addrs[i] = val
	}
	return
}

func LookupPort(network, service string) (port int, err error) {
	panic("unimplemented")
	return 0, nil
}
