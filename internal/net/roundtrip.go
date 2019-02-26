// +build !js !wasm

package net

import "net/http"

// RoundTripper is an interface representing the ability to execute a single
// HTTP transaction, obtaining the Response for a given Request.
type RoundTripper struct{}

func (t *RoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	return nil, nil
}
