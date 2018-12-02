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

func valuePrepareString(ref int32) int64

func valueLoadString(ref int32, p []byte)

func getString(ref int32) string {
	ln := valuePrepareString(ref)
	b := make([]byte, ln)
	valueLoadString(ref, b)
	return string(b)
}

func prepareArrayOfRefs(ref int32) int64
func loadArrayOfRefs(ref int32, p []byte)

func getArrayOfRefs(ref int32) (out []int32) {
	ln := prepareArrayOfRefs(ref)
	out = make([]int32, ln/4)
	b := make([]byte, ln)
	loadArrayOfRefs(ref, b)
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

// func lookupAddr(addr string) (names []string, err error)
// func LookupCNAME(host string) (cname string, err error)
// func LookupHost(host string) (addrs []string, err error)
// func LookupPort(network, service string) (port int, err error)
// func LookupTXT(name string) ([]string, error)
// func Dial(network, address string) (Conn, error)
