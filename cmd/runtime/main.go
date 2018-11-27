package main

import (
	"bytes"
	"crypto/rand"
	"encoding/binary"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/perlin-network/life/compiler"
	"github.com/perlin-network/life/exec"
)

var (
	vm  *exec.VirtualMachine
	err error
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	if len(os.Args) < 2 {
		log.Fatal("No wasm bin")
	}
	absPath, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	input, err := ioutil.ReadFile(absPath)
	if err != nil {
		log.Fatal(err)
	}
	vm, err = exec.NewVirtualMachine(input, exec.VMConfig{}, new(Resolver), &compiler.SimpleGasPolicy{})
	if err != nil { // if the wasm bytecode is invalid
		log.Fatal(err)
	}
	code, ok := vm.GetFunctionExport("run")
	if ok != true {
		log.Fatal("no run function")
	}
	fmt.Println(vm.FunctionCode[code].NumParams)
	vm.Run(code, 0, 0)
	// vm.FunctionCode[0].
}

// VM is an exec.VirtualMachine with utility functions
type VM struct {
	exec.VirtualMachine
}

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

func getInt64(mem []byte, addr int64) int64 {
	var out int64
	getInt(mem[addr:addr+8], &out)
	return out
}

func getInt32(mem []byte, addr int64) int32 {
	var out int32
	getInt(mem[addr:addr+4], &out)
	return out
}

func setInt64(mem []byte, addr int64, in int64) int32 {
	buf := writeInt(in)
	_, err := buf.Read(mem[addr : addr+8])
	if err != nil {
		panic(err)
	}
	return 0
}

func setInt32(mem []byte, addr int64, in int32) int32 {
	buf := writeInt(in)
	_, err := buf.Read(mem[addr : addr+8])
	if err != nil {
		panic(err)
	}
	return 0
}

func loadString(mem []byte, addr int64) string {
	saddr := getInt64(mem, addr+0)
	ln := getInt64(mem, addr+8)
	return string(mem[saddr : saddr+ln])
}

// Resolver resolves
type Resolver struct{}

// ResolveFunc resolverfuncs
func (r *Resolver) ResolveFunc(module, field string) exec.FunctionImport {
	log.Println("registering func", module, field)
	switch module {
	case "go":
		switch field {
		case "debug":
			return func(vm *exec.VirtualMachine) int64 {
				vm.PrintStackTrace()
				return 0
			}
		case "syscall/js.valueGet":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				fmt.Println("valueGet key: ", loadString(vm.Memory, sp+16))
				return 0
			}
		case "syscall/wasm.getRandomData":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				addr := getInt64(vm.Memory, sp+8)
				ln := getInt32(vm.Memory, sp+16)
				_, err := rand.Read(vm.Memory[addr : addr+int64(ln)])
				if err != nil {
					panic(err)
				}
				return 0
			}
		case "runtime.getRandomData":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				addr := getInt64(vm.Memory, sp+8)
				ln := getInt32(vm.Memory, sp+16)
				_, err := rand.Read(vm.Memory[addr : addr+int64(ln)])
				if err != nil {
					panic(err)
				}
				return 0
			}
		case "runtime.walltime":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				now := time.Now()
				sec := now.Unix()
				nsec := int32(now.UnixNano() - sec*1000000000)
				setInt64(vm.Memory, sp+8, sec)
				setInt32(vm.Memory, sp+16, nsec)
				return 0
			}
		case "runtime.wasmExit":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				exitCode := getInt32(vm.Memory, sp+8)
				if exitCode != 0 {
					log.Printf("Wasm exited with a non-zero exit code: %d\n", exitCode)
				}
				return 0
			}
		case "runtime.nanotime":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				setInt64(vm.Memory, sp+8, time.Now().UnixNano())
				return 0
			}
		case "syscall.wasmWrite":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				_ = getInt64(vm.Memory, sp+8) // file descriptor
				addr := getInt64(vm.Memory, sp+16)
				ln := getInt32(vm.Memory, sp+24)
				fmt.Print(string(vm.Memory[addr : addr+int64(ln)]))
				return 0
			}
		case "runtime.wasmWrite":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				_ = getInt64(vm.Memory, sp+8) // file descriptor
				addr := getInt64(vm.Memory, sp+16)
				ln := getInt32(vm.Memory, sp+24)
				fmt.Print(string(vm.Memory[addr : addr+int64(ln)]))
				return 0
			}
		default:
			return func(vm *exec.VirtualMachine) int64 {
				log.Println("func called", module, field)
				return 0
			}
		}
	default:
		panic(fmt.Errorf("unknown module: %s", module))
	}
}

// ResolveGlobal resolverglobsals
func (r *Resolver) ResolveGlobal(module, field string) int64 {
	log.Println("glob", module, field)
	panic("we're not resolving global variables for now")
	return 0
}
