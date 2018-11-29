// Copyright 2018 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// js/wasm uses fake networking directly implemented in the net package.
// This file only exists to make the compiler happy.

// +build js,wasm

package syscall

import "sync"

const (
	AF_UNSPEC = iota
	AF_UNIX
	AF_INET
	AF_INET6
)

const (
	SOCK_STREAM = 1 + iota
	SOCK_DGRAM
	SOCK_RAW
	SOCK_SEQPACKET
)

const (
	IPPROTO_IP   = 0
	IPPROTO_IPV4 = 4
	IPPROTO_IPV6 = 0x29
	IPPROTO_TCP  = 6
	IPPROTO_UDP  = 0x11
)

const (
	_ = iota
	IPV6_V6ONLY
	SOMAXCONN
	SO_ERROR
	TCP_NODELAY
	TCP_KEEPINTVL
	TCP_KEEPIDLE
)

// Misc constants expected by package net but not supported.
const (
	_ = iota
	F_DUPFD_CLOEXEC
	SYS_FCNTL = 500 // unsupported; same value as net_nacl.go
)

type Sockaddr interface {
}

type SockaddrInet4 struct {
	Port int
	Addr [4]byte
}

type SockaddrInet6 struct {
	Port   int
	ZoneId uint32
	Addr   [16]byte
}

type SockaddrUnix struct {
	Name string
}

func Socket(proto, sotype, unused int) (fd int, err error) {
	return 0, ENOSYS
}

func Bind(fd int, sa Sockaddr) error {
	return ENOSYS
}

func StopIO(fd int) error {
	return ENOSYS
}

func Listen(fd int, backlog int) error {
	return ENOSYS
}

func Accept(fd int) (newfd int, sa Sockaddr, err error) {
	return 0, nil, ENOSYS
}

func Connect(fd int, sa Sockaddr) error {
	return ENOSYS
}

func Recvfrom(fd int, p []byte, flags int) (n int, from Sockaddr, err error) {
	return 0, nil, ENOSYS
}

func Sendto(fd int, p []byte, flags int, to Sockaddr) error {
	return ENOSYS
}

func Recvmsg(fd int, p, oob []byte, flags int) (n, oobn, recvflags int, from Sockaddr, err error) {
	return 0, 0, 0, nil, ENOSYS
}

func SendmsgN(fd int, p, oob []byte, to Sockaddr, flags int) (n int, err error) {
	return 0, ENOSYS
}

func GetsockoptInt(fd, level, opt int) (value int, err error) {
	return 0, ENOSYS
}

func SetsockoptInt(fd, level, opt int, value int) error {
	return nil
}

func SetReadDeadline(fd int, t int64) error {
	return ENOSYS
}

func SetWriteDeadline(fd int, t int64) error {
	return ENOSYS
}

func Shutdown(fd int, how int) error {
	return ENOSYS
}

func SetNonblock(fd int, nonblocking bool) error {
	return nil
}

// Interface to timers implemented in package runtime.
// Must be in sync with ../runtime/time.go:/^type timer
// Really for use by package time, but we cannot import time here.

type runtimeTimer struct {
	tb uintptr
	i  int

	when   int64
	period int64
	f      func(interface{}, uintptr) // NOTE: must not be closure
	arg    interface{}
	seq    uintptr
}

func startTimer(*runtimeTimer)
func stopTimer(*runtimeTimer) bool

type timer struct {
	expired bool
	q       *queue
	r       runtimeTimer
}

func (t *timer) start(q *queue, deadline int64) {
	if deadline == 0 {
		return
	}
	t.q = q
	t.r.when = deadline
	t.r.f = timerExpired
	t.r.arg = t
	startTimer(&t.r)
}

func (t *timer) stop() {
	if t.r.f == nil {
		return
	}
	stopTimer(&t.r)
}

func (t *timer) reset(q *queue, deadline int64) {
	t.stop()
	if deadline == 0 {
		return
	}
	if t.r.f == nil {
		t.q = q
		t.r.f = timerExpired
		t.r.arg = t
	}
	t.r.when = deadline
	startTimer(&t.r)
}

func timerExpired(i interface{}, seq uintptr) {
	t := i.(*timer)
	go func() {
		t.q.Lock()
		defer t.q.Unlock()
		t.expired = true
		t.q.canRead.Broadcast()
		t.q.canWrite.Broadcast()
	}()
}

// A queue is the bookkeeping for a synchronized buffered queue.
// We do not use channels because we need to be able to handle
// writes after and during close, and because a chan byte would
// require too many send and receive operations in real use.
type queue struct {
	sync.Mutex
	canRead  sync.Cond
	canWrite sync.Cond
	rtimer   *timer // non-nil if in read
	wtimer   *timer // non-nil if in write
	r        int    // total read index
	w        int    // total write index
	m        int    // index mask
	closed   bool
}

func (q *queue) init(size int) {
	if size&(size-1) != 0 {
		panic("invalid queue size - must be power of two")
	}
	q.canRead.L = &q.Mutex
	q.canWrite.L = &q.Mutex
	q.m = size - 1
}

func past(deadline int64) bool {
	sec, nsec := now()
	return deadline > 0 && deadline < sec*1e9+int64(nsec)
}

func (q *queue) waitRead(n int, deadline int64) (int, error) {
	if past(deadline) {
		return 0, EAGAIN
	}
	var t timer
	t.start(q, deadline)
	q.rtimer = &t
	for q.w-q.r == 0 && !q.closed && !t.expired {
		q.canRead.Wait()
	}
	q.rtimer = nil
	t.stop()
	m := q.w - q.r
	if m == 0 && t.expired {
		return 0, EAGAIN
	}
	if m > n {
		m = n
		q.canRead.Signal() // wake up next reader too
	}
	q.canWrite.Signal()
	return m, nil
}

func (q *queue) waitWrite(n int, deadline int64) (int, error) {
	if past(deadline) {
		return 0, EAGAIN
	}
	var t timer
	t.start(q, deadline)
	q.wtimer = &t
	for q.w-q.r > q.m && !q.closed && !t.expired {
		q.canWrite.Wait()
	}
	q.wtimer = nil
	t.stop()
	m := q.m + 1 - (q.w - q.r)
	if m == 0 && t.expired {
		return 0, EAGAIN
	}
	if m == 0 {
		return 0, EAGAIN
	}
	if m > n {
		m = n
		q.canWrite.Signal() // wake up next writer too
	}
	q.canRead.Signal()
	return m, nil
}

func (q *queue) close() {
	q.Lock()
	defer q.Unlock()
	q.closed = true
	q.canRead.Broadcast()
	q.canWrite.Broadcast()
}

// A byteq is a byte queue.
type byteq struct {
	queue
	data []byte
}

func newByteq() *byteq {
	q := &byteq{
		data: make([]byte, 4096),
	}
	q.init(len(q.data))
	return q
}

func (q *byteq) read(b []byte, deadline int64) (int, error) {
	q.Lock()
	defer q.Unlock()
	n, err := q.waitRead(len(b), deadline)
	if err != nil {
		return 0, err
	}
	b = b[:n]
	for len(b) > 0 {
		m := copy(b, q.data[q.r&q.m:])
		q.r += m
		b = b[m:]
	}
	return n, nil
}

func (q *byteq) write(b []byte, deadline int64) (n int, err error) {
	q.Lock()
	defer q.Unlock()
	for n < len(b) {
		nn, err := q.waitWrite(len(b[n:]), deadline)
		if err != nil {
			return n, err
		}
		bb := b[n : n+nn]
		n += nn
		for len(bb) > 0 {
			m := copy(q.data[q.w&q.m:], bb)
			q.w += m
			bb = bb[m:]
		}
	}
	return n, nil
}

// RoutingMessage represents a routing message.
type RoutingMessage interface {
	unimplemented()
}
