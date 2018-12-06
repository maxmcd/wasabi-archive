package main

import (
	"bytes"
	"crypto/rand"
	"encoding/binary"
	"fmt"
	"log"
	"net"
	"os"
	"time"

	"github.com/go-interpreter/wagon/exec"
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
	vm      *exec.VM
	envVars map[string]string
	values  map[int][]byte
	ffi     map[string]func(int32)
	locals  []int32
}

func (r *Resolver) init() {
	r.envVars = make(map[string]string)
	r.values = make(map[int][]byte)
	r.ffi = map[string]func(int32){
		"env/println": r.envPrintln,
		"go/debug":    r.goDebug,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.getenv":             r.goGowasmGetEnv,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.getRandomData":      r.goGetRandomData,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.loadArrayOfRefs":    r.goWasmLoadBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.lookupAddr":         r.goGowasmLookupAddr,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.prepareArrayOfRefs": r.goWasmPrepareBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.setenv":             r.goGowasmSetEnv,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.valueLoadString":    r.goWasmLoadBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.valuePrepareString": r.goWasmPrepareBytes,
		"go/github.com/maxmcd/wasm-servers/pkg/gowasm.write":              r.goGowasmWrite,
		"go/runtime.clearScheduledCallback":                               r.noop,
		"go/runtime.getRandomData":                                        r.goGetRandomData,
		"go/runtime.nanotime":                                             r.goRuntimeNanotime,
		"go/runtime.scheduleCallback":                                     r.noop,
		"go/runtime.walltime":                                             r.goRuntimeWallTime,
		"go/runtime.wasmExit":                                             r.goRuntimeWasmExit,
		"go/runtime.wasmWrite":                                            r.goWasmWrite,
		"go/syscall.Syscall":                                              r.noop,
		"go/syscall.wasmWrite":                                            r.goWasmWrite,
		"go/syscall/js.valueGet":                                          r.goSyscallJsValueGet,
		"go/syscall/wasm.getRandomData":                                   r.goGetRandomData,
	}
}

// func (r *Resolver) callFunc(vm *exec.VirtualMachine, module, field string) {
// 	r.vm = vm
// 	f, ok := r.ffi[module+"/"+field]
// 	if !ok {
// 		log.Println("No function")
// 	} else {
// 		f()
// 	}
// }

func (r *Resolver) noop(sp int32) {
	fmt.Println(sp, "noop")
}

func (r *Resolver) getInt64(addr int32) (out int64) {
	getInt(r.vm.Memory()[addr:addr+8], &out)
	return out
}

func (r *Resolver) getUint64(addr int32) (out uint64) {
	getInt(r.vm.Memory()[addr:addr+8], &out)
	return out
}

func (r *Resolver) getInt32(addr int32) (out int32) {
	getInt(r.vm.Memory()[addr:addr+4], &out)
	return
}

func (r *Resolver) getUint32(addr int32) (out uint32) {
	getInt(r.vm.Memory()[addr:addr+4], &out)
	return
}

func (r *Resolver) setInt64(addr int32, in int64) {
	buf := writeInt(in)
	_, err := buf.Read(r.vm.Memory()[addr : addr+8])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) setInt32(addr int32, in int32) {
	buf := writeInt(in)
	_, err := buf.Read(r.vm.Memory()[addr : addr+4])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) loadString(addr int32) string {
	saddr := r.getInt64(addr)
	ln := r.getInt64(addr + 8)
	return string(r.vm.Memory()[saddr : saddr+ln])
}

func (r *Resolver) goDebug(sp int32) {
	fmt.Println(sp, "go debug called")
}

// "go/syscall/js.valueGet"
func (r *Resolver) goSyscallJsValueGet(sp int32) {
	fmt.Println("valueGet key: ", r.loadString(sp+16))
}

func (r *Resolver) goWasmLoadBytes(sp int32) {
	ref := r.getUint32(sp + 8)
	addr := r.getInt64(sp + 16)
	ln := r.getInt32(sp + 24)
	copy(r.vm.Memory()[addr:addr+int64(ln)], r.values[int(ref)])
	r.values[int(ref)] = []byte{}
}

func (r *Resolver) goWasmPrepareBytes(sp int32) {
	ref := r.getInt32(sp + 8)
	r.setInt64(sp+16, int64(len(r.values[int(ref)])))
}

func (r *Resolver) goGowasmSetEnv(sp int32) {
	key := r.loadString(sp + 8)
	value := r.loadString(sp + 24)
	r.envVars[key] = value
}

func (r *Resolver) goGowasmGetEnv(sp int32) {
	v, ok := r.envVars[r.loadString(sp+8)]
	r.setBool(sp+24, ok)
	if ok {
		r.setString(sp+24+4, v)
	}
}

func (r *Resolver) goGowasmWrite(sp int32) {
	_ = r.getInt64(sp + 8) // file descriptor
	fmt.Print(r.loadString(sp + 16))
}

func (r *Resolver) goGetRandomData(sp int32) {
	addr := r.getInt64(sp + 8)
	ln := r.getInt32(sp + 16)
	_, err := rand.Read(r.vm.Memory()[addr : addr+int64(ln)])
	if err != nil {
		panic(err)
	}
}

func (r *Resolver) goRuntimeWallTime(sp int32) {
	now := time.Now()
	sec := now.Unix()
	nsec := int32(now.UnixNano() - sec*1000000000)
	r.setInt64(sp+8, sec)
	r.setInt32(sp+16, nsec)
}

func (r *Resolver) goRuntimeWasmExit(sp int32) {
	exitCode := r.getInt32(sp + 8)
	if exitCode != 0 {
		log.Printf("Wasm exited with a non-zero exit code: %d\n", exitCode)
		os.Exit(int(exitCode))
	}
}

func (r *Resolver) goRuntimeNanotime(sp int32) {
	r.setInt64(sp+8, time.Now().UnixNano())
}

func (r *Resolver) goWasmWrite(sp int32) {
	_ = r.getInt64(sp + 8) // file descriptor
	fmt.Print(r.loadString(sp + 16))
}

func (r *Resolver) setBool(addr int32, in bool) {
	if in {
		r.vm.Memory()[addr] = 1
	} else {
		r.vm.Memory()[addr] = 0
	}
}

func (r *Resolver) setString(addr int32, val string) {
	r.setInt32(addr, r.storeValue([]byte(val)))
}

func (r *Resolver) setStringArray(addr int32, vals []string) {
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

func (r *Resolver) goGowasmLookupAddr(sp int32) {
	addr := r.loadString(sp + 8)
	names, err := net.LookupAddr(addr)
	r.setBool(sp+24+4, err == nil)
	if err != nil {
		r.setString(sp+24, err.Error())
	} else {
		r.setStringArray(sp+24, names)
	}
}

func (r *Resolver) envPrintln(sp int32) {
	addr := r.locals[0]
	ln := r.locals[1]
	fmt.Println(string(r.vm.Memory()[addr : addr+ln]))
}

// // ResolveFunc resolverfuncs
// func (r *Resolver) ResolveFunc(module, field string) exec.FunctionImport {
// 	fmt.Println("registering func", module, field)
// 	return func(vm *exec.VirtualMachine) int64 {
// 		// fmt.Println("called func", module, field)
// 		r.callFunc(vm, module, field)
// 		return 0
// 	}
// }

// // ResolveGlobal resolverglobsals
// func (r *Resolver) ResolveGlobal(module, field string) int64 {
// 	fmt.Println("glob", module, field)
// 	panic("we're not resolving global variables for now")
// 	return 0
// }
