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

	start = time.Now()
	entry := m.Export.Entries["run"]
	_, err = vm.ExecCode(int64(entry.Index), uint64(0), uint64(0))
	if err != nil {
		panic(err)
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
			ParamTypes:  []wasm.ValueType{wasm.ValueTypeI32},
			ReturnTypes: nil,
		}
		m.Types.Entries = append(m.Types.Entries, sig)
		wasmFun := wasm.Function{
			Sig: &sig,
			Host: reflect.ValueOf(func(proc *exec.Process, sp int32) {
				fmt.Println("calling", methodName)
				functionLocal(sp)
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
