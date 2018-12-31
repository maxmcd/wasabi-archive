// +build !js !wasm

package http

import "net/http"

// RoundTrip implements the RoundTripper interface
func roundTrip(req *http.Request) (*http.Response, error) {
	return http.DefaultTransport.RoundTrip(req)
}
