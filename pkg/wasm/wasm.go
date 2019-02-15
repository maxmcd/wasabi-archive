// +build !js !wasm

package wasm

import "errors"

// GetBytes returns the byte contents of a referenced value in the
// runtime environment This menthod only works with the wasabi runtime
func GetBytes(ref int32) ([]byte, error) {
	return nil, errors.New("not implemented")
}

// GetArrayOfRefs returns an array of references to values stored in the
// runtime environment. This menthod only works with the wasabi runtime
func GetArrayOfRefs(ref int32) (out []int32, err error) {
	return nil, errors.New("not implemented")
}
