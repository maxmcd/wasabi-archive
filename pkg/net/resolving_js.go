// +build js,wasm

package net

import (
	"errors"
	"net"

	"github.com/maxmcd/wasabi/pkg/wasm"
)

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
