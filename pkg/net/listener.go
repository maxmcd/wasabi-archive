// +build !js !wasm

package net

import (
	"net"
	"net/http"
	"time"
)

type TcpListener struct {
	net.Listener
}

type tcpKeepAliveListener struct {
	*net.TCPListener
}

func (ln tcpKeepAliveListener) Accept() (net.Conn, error) {
	tc, err := ln.AcceptTCP()
	if err != nil {
		return nil, err
	}
	tc.SetKeepAlive(true)
	tc.SetKeepAlivePeriod(3 * time.Minute)
	return tc, nil
}

func ListenAndServe(a string, handler http.Handler) error {
	server := &http.Server{Addr: a, Handler: handler}
	// if server.shuttingDown() {
	// 	return http.ErrServerClosed
	// }
	addr := server.Addr
	if addr == "" {
		addr = ":http"
	}
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	return server.Serve(TcpListener{ln.(*net.TCPListener)})
}
