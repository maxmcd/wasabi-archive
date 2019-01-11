// +build !js,!wasm

package gowasm

import (
	"crypto/rand"
)

func GetRandomData(r []byte) {
	rand.Read(r)
}
