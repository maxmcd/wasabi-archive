package main

import (
	"bytes"
	"crypto/rand"
	"encoding/binary"
	"fmt"
	"log"
	"net"
	"time"

	"github.com/perlin-network/life/exec"
)

func getInt(in []byte, out interface{}) {
	buf := bytes.NewReader(in)
	err := binary.Read(buf, binary.LittleEndian, out)
	if err != nil {
		panic(err)
	}
}

func writeInt(in interface{}) *bytes.Buffer {
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, in)
	if err != nil {
		panic(err)
	}
	return buf
}

// Resolver is an exec.VirtualMachine with utility functions
type Resolver struct {
	vm      *exec.VirtualMachine
	envVars map[string]string
	values  map[int][]byte
	ffi     map[string]func()
}

func (r *Resolver) init() {
	r.envVars = make(map[string]string)
	r.values = make(map[int][]byte)
	r.ffi = map[string]func(){
		"go/debug":                                                        r.goDebug,
		"go/syscall/js.valueGet":                                          r.goSyscallJsValueGet,
		"go/syscall/wasm.getRandomData":                                   r.goGetRandomData,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.valueLoadString":    r.goWasmLoadBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.valuePrepareString": r.goWasmPrepareBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.loadArrayOfRefs":    r.goWasmLoadBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.prepareArrayOfRefs": r.goWasmPrepareBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.lookupAddr":         r.goGowasmLookupAddr,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.getenv":             r.goGowasmGetEnv,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.setenv":             r.goGowasmSetEnv,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.write":              r.goGowasmWrite,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.getRandomData":      r.goGetRandomData,
		"go/runtime.getRandomData":                                        r.goGetRandomData,
		"go/runtime.walltime":                                             r.goRuntimeWallTime,
		"go/runtime.wasmExit":                                             r.goRuntimeWasmExit,
		"go/runtime.nanotime":                                             r.goRuntimeNanotime,
		"go/syscall.wasmWrite":                                            r.goWasmWrite,
		"go/runtime.wasmWrite":                                            r.goWasmWrite,
		"env/println":                                                     r.envPrintln,
	}
}
func (r *Resolver) callFunc(vm *exec.VirtualMachine, module, field string) {
	r.vm = vm
	f, ok := r.ffi[module+"/"+field]
	if !ok {
		log.Println("No function")
	} else {
		f()
	}
}

func (r *Resolver) getInt64(addr int64) (out int64) {
	getInt(r.vm.Memory[addr:addr+8], &out)
	return out
}

func (r *Resolver) getUint64(addr int64) (out uint64) {
	getInt(r.vm.Memory[addr:addr+8], &out)
	return out
}

func (r *Resolver) getInt32(addr int64) (out int32) {
	getInt(r.vm.Memory[addr:addr+4], &out)
	return
}

func (r *Resolver) getUint32(addr int64) (out uint32) {
	getInt(r.vm.Memory[addr:addr+4], &out)
	return
}

func (r *Resolver) setInt64(addr int64, in int64) {
	buf := writeInt(in)
	_, err := buf.Read(r.vm.Memory[addr : addr+8])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) setInt32(addr int64, in int32) {
	buf := writeInt(in)
	_, err := buf.Read(r.vm.Memory[addr : addr+4])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) loadString(addr int64) string {
	saddr := r.getInt64(addr)
	ln := r.getInt64(addr + 8)
	return string(r.vm.Memory[saddr : saddr+ln])
}

func (r *Resolver) sp() int64 {
	return r.vm.GetCurrentFrame().Locals[0]
}

func (r *Resolver) goDebug() {
	r.vm.PrintStackTrace()
}

// "go/syscall/js.valueGet"
func (r *Resolver) goSyscallJsValueGet() {
	sp := r.sp()
	fmt.Println("valueGet key: ", r.loadString(sp+16))
}

func (r *Resolver) goWasmLoadBytes() {
	sp := r.sp()
	ref := r.getUint32(sp + 8)
	addr := r.getInt64(sp + 16)
	ln := r.getInt32(sp + 24)
	copy(vm.Memory[addr:addr+int64(ln)], r.values[int(ref)])
	r.values[int(ref)] = []byte{}
}

func (r *Resolver) goWasmPrepareBytes() {
	sp := r.sp()
	ref := r.getInt32(sp + 8)
	r.setInt64(sp+16, int64(len(r.values[int(ref)])))
}

func (r *Resolver) goGowasmSetEnv() {
	sp := r.sp()
	key := r.loadString(sp + 8)
	value := r.loadString(sp + 24)
	r.envVars[key] = value
}

func (r *Resolver) goGowasmGetEnv() {
	sp := r.sp()
	v, ok := r.envVars[r.loadString(sp+8)]
	r.setBool(sp+24, ok)
	if ok {
		r.setString(sp+24+4, v)
	}
}

func (r *Resolver) goGowasmWrite() {
	sp := vm.GetCurrentFrame().Locals[0]
	_ = r.getInt64(sp + 8) // file descriptor
	fmt.Print(r.loadString(sp + 16))
}

func (r *Resolver) goGetRandomData() {
	sp := r.sp()
	addr := r.getInt64(sp + 8)
	ln := r.getInt32(sp + 16)
	_, err := rand.Read(vm.Memory[addr : addr+int64(ln)])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) goRuntimeWallTime() {
	sp := r.sp()
	now := time.Now()
	sec := now.Unix()
	nsec := int32(now.UnixNano() - sec*1000000000)
	r.setInt64(sp+8, sec)
	r.setInt32(sp+16, nsec)
}

func (r *Resolver) goRuntimeWasmExit() {
	sp := r.sp()
	exitCode := r.getInt32(sp + 8)
	if exitCode != 0 {
		log.Printf("Wasm exited with a non-zero exit code: %d\n", exitCode)
	}
}

func (r *Resolver) goRuntimeNanotime() {
	sp := r.sp()
	r.setInt64(sp+8, time.Now().UnixNano())
}

func (r *Resolver) goWasmWrite() {
	sp := r.sp()
	_ = r.getInt64(sp + 8) // file descriptor
	fmt.Print(r.loadString(sp + 16))
}

func (r *Resolver) setBool(addr int64, in bool) {
	if in {
		r.vm.Memory[addr] = 1
	} else {
		r.vm.Memory[addr] = 0
	}
}

func (r *Resolver) setString(addr int64, val string) {
	r.setInt32(addr, r.storeValue([]byte(val)))
}

func (r *Resolver) setStringArray(addr int64, vals []string) {
	v := make([]byte, len(vals)*4)
	for i, val := range vals {
		buf := writeInt(r.storeValue([]byte(val)))
		_, err := buf.Read(v[i*4 : i*4+4])
		if err != nil {
			panic(err)
		}
	}
	r.setInt32(addr, r.storeValue(v))
}

func (r *Resolver) storeValue(b []byte) (ref int32) {
	_ref := len(r.values)
	r.values[_ref] = b
	ref = int32(_ref)
	return
}

func (r *Resolver) goGowasmLookupAddr() {
	sp := r.sp()
	addr := r.loadString(sp + 8)
	names, err := net.LookupAddr(addr)
	r.setBool(sp+24+4, err == nil)
	if err != nil {
		r.setString(sp+24, err.Error())
	} else {
		r.setStringArray(sp+24, names)
	}
}

func (r *Resolver) envPrintln() {
	addr := r.vm.GetCurrentFrame().Locals[0]
	ln := r.vm.GetCurrentFrame().Locals[1]
	fmt.Print(string(vm.Memory[addr : addr+ln]))
}

// ResolveFunc resolverfuncs
func (r *Resolver) ResolveFunc(module, field string) exec.FunctionImport {
	log.Println("registering func", module, field)
	return func(vm *exec.VirtualMachine) int64 {
		log.Println("called func", module, field)
		r.callFunc(vm, module, field)
		return 0
	}
}

// ResolveGlobal resolverglobsals
func (r *Resolver) ResolveGlobal(module, field string) int64 {
	log.Println("glob", module, field)
	panic("we're not resolving global variables for now")
	return 0
}
