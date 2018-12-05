// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build nacl js,wasm

package net

import (
	"context"
	"syscall"
)

func lookupProtocol(ctx context.Context, name string) (proto int, err error) {
	println(name)
	return lookupProtocolMap(name)
}

func (*Resolver) lookupHost(ctx context.Context, host string) (addrs []string, err error) {
	println("lookupHost")
	return nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupIP(ctx context.Context, host string) (addrs []IPAddr, err error) {
	println("lookupIP")
	return nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupPort(ctx context.Context, network, service string) (port int, err error) {
	println("lookupPort")
	return goLookupPort(network, service)
}

func (*Resolver) lookupCNAME(ctx context.Context, name string) (cname string, err error) {
	println("lookupCNAME")
	return "", syscall.ENOPROTOOPT
}

func (*Resolver) lookupSRV(ctx context.Context, service, proto, name string) (cname string, srvs []*SRV, err error) {
	println("lookupSRV")
	return "", nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupMX(ctx context.Context, name string) (mxs []*MX, err error) {
	println("lookupMX")
	return nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupNS(ctx context.Context, name string) (nss []*NS, err error) {
	println("lookupNS")
	return nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupTXT(ctx context.Context, name string) (txts []string, err error) {
	println("lookupTXT")
	return nil, syscall.ENOPROTOOPT
}

func (*Resolver) lookupAddr(ctx context.Context, addr string) (ptrs []string, err error) {
	println("lookupAddr")
	return nil, syscall.ENOPROTOOPT
}

// concurrentThreadsLimit returns the number of threads we permit to
// run concurrently doing DNS lookups.
func concurrentThreadsLimit() int {
	return 500
}
