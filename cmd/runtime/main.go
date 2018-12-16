package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"time"

	"github.com/go-interpreter/wagon/exec"
	"github.com/go-interpreter/wagon/wasm"
)

type extrypoint struct {
	args []uint64
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
	file, err := os.Open(absPath)
	if err != nil {
		log.Fatal(err)
	}
	r := new(Resolver)
	r.init()

	start := time.Now()
	m, err := wasm.ReadModule(file, func(module string) (*wasm.Module, error) {
		fmt.Println(module)
		return registerModule(module, r), nil
	})

	if err != nil {
		log.Fatal(err)
	}
	vm, err := exec.NewVM(m)
	if err != nil {
		log.Fatal(err)
	}
	r.vm = vm
	fmt.Printf("Completed parsing bin in %s\n", time.Now().Sub(start))

	eps := []extrypoint{
		{args: []uint64{0, 0}, name: "run"},
		{args: []uint64{}, name: "main"},
	}
	start = time.Now()
	var run bool
	for _, ep := range eps {
		_, ok := m.Export.Entries[ep.name]
		if ok == true {
			run = true
			entry := m.Export.Entries[ep.name]
			_, err = vm.ExecCode(int64(entry.Index), ep.args...)
			if err != nil {
				panic(err)
			}
			break
		}
	}
	if !run {
		log.Fatal("Entrypoint command found")
	}
	fmt.Printf("Run complete %s\n", time.Now().Sub(start))
}

func registerModule(module string, r *Resolver) *wasm.Module {
	m := wasm.NewModule()
	m.Export.Entries = map[string]wasm.ExportEntry{}

	for name, fun := range r.ffi {
		functionLocal := fun
		parts := strings.SplitN(name, "/", 2)
		moduleName := parts[0]
		methodName := parts[1]
		if moduleName != module {
			continue
		}
		sig := wasm.FunctionSig{
			Form:        0,
			ParamTypes:  []wasm.ValueType{wasm.ValueTypeI32, wasm.ValueTypeI32},
			ReturnTypes: nil,
		}
		m.Types.Entries = append(m.Types.Entries, sig)
		wasmFun := wasm.Function{
			Sig: &sig,
			Host: reflect.ValueOf(func(proc *exec.Process, sp int32, sp2 int32) {
				fmt.Println("calling", methodName)
				r.locals = []int32{sp, sp2}
				functionLocal(sp2)
			}),
			Body: &wasm.FunctionBody{},
		}
		m.FunctionIndexSpace = append(m.FunctionIndexSpace, wasmFun)
		m.Export.Entries[methodName] = wasm.ExportEntry{
			FieldStr: methodName,
			Kind:     wasm.ExternalFunction,
			Index:    uint32(len(m.FunctionIndexSpace) - 1),
		}
	}
	return m
}
