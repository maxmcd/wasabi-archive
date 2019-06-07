package handler

import (
	"bytes"
	"net/http"
)

type ResponseWriter struct {
	H          http.Header
	Body       bytes.Buffer
	StatusCode int
}

func (rw *ResponseWriter) Header() http.Header {
	return rw.H
}

func (rw *ResponseWriter) Write(b []byte) (int, error) {
	return rw.Body.Write(b)
}

func (rw *ResponseWriter) WriteHeader(statusCode int) {
	rw.StatusCode = statusCode
}
