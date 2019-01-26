// +build js,wasm

package wasm

import (
	"bytes"
	"encoding/binary"
)

func prepareBytes(ref int32) int64

func loadBytes(ref int32, p []byte)

// GetBytes returns the byte contents of a referenced value in the
// runtime environment This menthod only works with the wasabi runtime
func GetBytes(ref int32) ([]byte, error) {
	ln := prepareBytes(ref)
	b := make([]byte, ln)
	loadBytes(ref, b)
	return b, nil
}

// GetArrayOfRefs returns an array of references to values stored in the
// runtime environment. This menthod only works with the wasabi runtime
func GetArrayOfRefs(ref int32) (out []int32, err error) {
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
