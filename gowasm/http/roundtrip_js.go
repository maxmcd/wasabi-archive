// +build js,wasm
package http

import (
	"encoding/json"
	"errors"
	"net/http"
)

type requestData struct {
	Headers map[string][]string
	URL     string
	Method  string
	Body    bool
}

func newRequestData(req *http.Request) (rd requestData) {
	rd.Body = req.Body != nil
	rd.Headers = make(map[string][]string)
	for key, values := range req.Header {
		rd.Headers[key] = make([]string, len(values))
		for i, value := range values {
			rd.Headers[key][i] = value
		}
	}
	rd.Method = req.Method
	rd.URL = req.URL.String()
	return
}

// TODO: stream body
func startRequest(data []byte, body []byte) (id, err int)

// RoundTrip implements the RoundTripper interface
func roundTrip(req *http.Request) (*http.Response, error) {
	rd := newRequestData(req)
	rdb, err := json.Marshal(rd)
	if err != nil {
		return nil, err
	}
	id, errref := startRequest(rdb, []byte("hi"))
	_ = id
	_ = errref
	return nil, errors.New("notimplemented")
}
