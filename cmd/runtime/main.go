package main

import (
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/perlin-network/life/compiler"
	"github.com/perlin-network/life/exec"
)

var (
	vm      *exec.VirtualMachine
	err     error
	envVars map[string]string
)

func main() {

	envVars = make(map[string]string)
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
	r := new(Resolver)
	r.init()

	vm, err = exec.NewVirtualMachine(input, exec.VMConfig{}, r, &compiler.SimpleGasPolicy{})
	if err != nil { // if the wasm bytecode is invalid
		log.Fatal(err)
	}
	code, ok := vm.GetFunctionExport("run")
	if ok != true {
		log.Println("no run function")
		code, ok = vm.GetFunctionExport("main")
		if ok != true {
			log.Println("no main function")
		}
		vm.Run(code)
		return
	}

	// fmt.Println(vm.FunctionCode[code].NumParams)

	vm.Run(code, 0, 0)
	// vm.FunctionCode[0].
}
