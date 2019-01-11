// +build js,wasm

package gowasm

import (
	"bytes"
	"encoding/binary"
	"errors"
)

func init() {

}
func getRandomData(r []byte)

func GetRandomData(r []byte) {
	getRandomData(r)
}

func write(fd int, p []byte) (n int64)

func Write(fd int, p []byte) (n int, err error) {
	// TODO: complete
	write(fd, p)
	return
}

func setenv(key, value string)

func Setenv(key, value string) {
	setenv(key, value)
}

func getenv(key string) (n bool, ref int32)

func Getenv(key string) (value string, found bool) {
	var ref int32
	found, ref = getenv(key)
	if found {
		value = getString(ref)
	}
	return
}

func prepareBytes(ref int32) int64

func loadBytes(ref int32, p []byte)

func getString(ref int32) string {
	ln := prepareBytes(ref)
	b := make([]byte, ln)
	loadBytes(ref, b)
	return string(b)
}

func getArrayOfRefs(ref int32) (out []int32) {
	ln := prepareBytes(ref)
	out = make([]int32, ln/4)
	b := make([]byte, ln)
	loadBytes(ref, b)
	for i := 0; i < int(ln/4); i++ {
		buf := bytes.NewReader(b[i*4 : i*4+4])
		if err := binary.Read(buf, binary.LittleEndian, &out[i]); err != nil {
			panic(err)
		}
	}
	return
}

// get ref and ok
// if not ok, ref is err string
// if ok ref is ref to ref list
func lookupAddr(addr string) (ref int32, err bool)

// func Clearenv
// func Environ
func LookupAddr(addr string) (names []string, err error) {
	ref, ok := lookupAddr(addr)
	if ok {
		refs := getArrayOfRefs(ref)
		names = make([]string, len(refs))
		for i, ref := range refs {
			names[i] = getString(ref)
		}
	} else {
		err = errors.New(getString(ref))
	}
	return
}

func lookupCNAME(addr string) (ref int32, err bool)

func LookupCNAME(addr string) (cname string, err error) {
	ref, ok := lookupCNAME(addr)
	if ok {
		cname = getString(ref)
	} else {
		err = errors.New(getString(ref))
	}
	return
}

func lookupHost(host string) (ref int32, err bool)

// func LookupHost(host string) (addrs []string, err error)
func LookupHost(host string) (names []string, err error) {
	ref, ok := lookupHost(host)
	if ok {
		refs := getArrayOfRefs(ref)
		names = make([]string, len(refs))
		for i, ref := range refs {
			names[i] = getString(ref)
		}
		return
	}
	err = errors.New(getString(ref))
	return
}

func lookupPort(network, service string) (port uint32, err bool, ref int32)

// func LookupPort(network, service string) (port int, err error)
func LookupPort(network, service string) (port int, err error) {
	_port, ok, ref := lookupPort(network, service)
	if ok {
		port = int(_port)
		return
	}
	err = errors.New(getString(ref))
	return
}

func lookupTXT(name string) (ref int32, err bool)

// func LookupTXT(name string) ([]string, error)
func LookupTXT(addr string) (names []string, err error) {
	ref, ok := lookupTXT(addr)
	if ok {
		refs := getArrayOfRefs(ref)
		names = make([]string, len(refs))
		for i, ref := range refs {
			names[i] = getString(ref)
		}
	} else {
		err = errors.New(getString(ref))
	}
	return
}
