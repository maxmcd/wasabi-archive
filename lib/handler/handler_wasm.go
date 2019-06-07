// +build wasm
package handler

import "net/http"

//go:export get_request
func read_request(data []byte) int32

// ServeRequest serves the request
func ServeRequest(handle func(http.ResponseWriter, *http.Request)) {
	data := make([]byte)
	read_request(&data)
}
