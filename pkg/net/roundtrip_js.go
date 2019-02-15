// +build js,wasm

package net

import (
	"fmt"
	"net/http"
)

// RoundTripper is an interface representing the ability to execute a single
// HTTP transaction, obtaining the Response for a given Request.
type RoundTripper struct{}

func (t *RoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	// copy lots from src/net/http/transport.go:399
	fmt.Println(req)
	return nil, nil
}
