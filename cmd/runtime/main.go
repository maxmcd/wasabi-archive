package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

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
	fmt.Println("go")
	vm, err = exec.NewVirtualMachine(input, exec.VMConfig{}, new(Resolver), &compiler.SimpleGasPolicy{})
	if err != nil { // if the wasm bytecode is invalid
		log.Fatal(err)
	}
	fmt.Println("go")
	fmt.Println(vm.GetFunctionExport("run"))
	code, ok := vm.GetFunctionExport("run")
	if ok != true {
		log.Fatal("no run function")
	}
	fmt.Println(vm.FunctionCode[code].NumParams)
	vm.Run(code, 0, 0)
	// vm.FunctionCode[0].
}

// Resolver resolves
type Resolver struct{}

// ResolveFunc resolverfuncs
func (r *Resolver) ResolveFunc(module, field string) exec.FunctionImport {
	log.Println("func", module, field)
	switch module {
	case "go":
		switch field {
		case "debug":
			return func(vm *exec.VirtualMachine) int64 {
				vm.PrintStackTrace()
				fmt.Println(vm.GetCurrentFrame().Regs)
				fmt.Println(vm.GetCurrentFrame().Locals)
				fmt.Println(vm.CurrentFrame)
				fmt.Println(vm.Memory[vm.CurrentFrame-8 : vm.CurrentFrame])
				return 0
			}
		case "runtime.wasmExit":
			return func(vm *exec.VirtualMachine) int64 {
				sp := vm.GetCurrentFrame().Locals[0]
				fmt.Println("wasmExit")
				fmt.Println(vm.Memory[sp+8 : sp+8+4])
				return 0
			}
		case "runtime.wasmWrite":
			return func(vm *exec.VirtualMachine) int64 {
				// vm.PrintStackTrace()
				sp := vm.GetCurrentFrame().Locals[0]
				fmt.Println(vm.Memory[sp+8 : sp+8+8])
				fmt.Println(vm.Memory[sp+8+8 : sp+8+8+8])
				fmt.Println(vm.Memory[sp+8+8+8 : sp+8+8+8+4])
				fmt.Println(vm.GetCurrentFrame().Regs)
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
