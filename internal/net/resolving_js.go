// +build js,wasm

package net

import (
	"errors"
	"fmt"
	"net"

	"github.com/maxmcd/wasabi/internal/wasm"
)

func lookupIP(host string) (int32, bool)

// LookupIP looks up host using the local resolver. It returns a slice of
// that host's IPv4 addresses.
func LookupIP(host string) (addrs []net.IP, err error) {
	ref, ok := lookupIP(host)
	if !ok {
		bytes, _ := wasm.GetBytes(ref)
		err = errors.New(string(bytes))
		return
	}
	refs, err := wasm.GetArrayOfRefs(ref)
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

func lookupPort(network, service string) (int32, bool)

func LookupPort(network, service string) (port int, err error) {
	ref, ok := lookupPort(network, service)
	fmt.Println(ref, ok)
	return 0, nil
}
