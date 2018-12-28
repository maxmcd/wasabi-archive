// +build js,wasm

package wasm

import (
	"bytes"
	"encoding/binary"
)

func getRandomData(r []byte)

func GetRandomData(r []byte) {
	getRandomData(r)
}

func prepareBytes(ref int32) int64

func loadBytes(ref int32, p []byte)

func GetBytes(ref int32) []byte {
	ln := prepareBytes(ref)
	b := make([]byte, ln)
	loadBytes(ref, b)
	return b
}

func GetArrayOfRefs(ref int32) (out []int32) {
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
