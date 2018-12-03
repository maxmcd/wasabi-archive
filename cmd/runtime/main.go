package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/perlin-network/life/compiler"
	"github.com/perlin-network/life/exec"
)

type extrypoint struct {
	args []int64
	name string
}

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
	r := new(Resolver)
	r.init()

	start := time.Now()
	vm, err := exec.NewVirtualMachine(input, exec.VMConfig{}, r, &compiler.SimpleGasPolicy{})
	if err != nil { // if the wasm bytecode is invalid
		log.Fatal(err)
	}
	fmt.Printf("Completed parsing bin in %s\n", time.Now().Sub(start))

	eps := []extrypoint{
		{args: []int64{0, 0}, name: "run"},
		{args: []int64{}, name: "main"},
	}
	start = time.Now()
	var run bool
	for _, ep := range eps {
		code, ok := vm.GetFunctionExport(ep.name)
		if ok == true {
			run = true
			vm.Run(code, ep.args...)
			break
		}
	}
	if !run {
		log.Fatal("Entrypoint command found")
	}
	fmt.Printf("Run complete %s\n", time.Now().Sub(start))

	// vm.FunctionCode[0].
}
