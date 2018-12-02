package main

import (
	"bytes"
	"log"

	"github.com/maxmcd/wasm-servers/pkg/gowasm"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	b := make([]byte, 10)
	gowasm.GetRandomData(b)

	if bytes.Equal(make([]byte, 10), b) {
		log.Fatal("Bytes should not be 0s")
	}

	gowasm.Write(1, []byte("helloo\n"))

	gowasm.Setenv("something", "value")
	val, ok := gowasm.Getenv("something")
	if ok != true {
		log.Fatal("ok should be true for getenv")
	}
	if val != "value" {
		log.Fatal("should have value for getenv")
	}
	val, ok = gowasm.Getenv("something-else")
	if ok != false {
		log.Fatal("no value should be present for getenv")
	}
	if val != "" {
		log.Fatal("also shouldn't have the value")
	}

	names, err := gowasm.LookupAddr("127.0.0.1")
	if err != nil {
		log.Fatal(err)
	}
	if len(names) == 0 {
		log.Println(names)
		log.Fatal("Names shouldn't be empty")
	}
	if names[0] != "localhost" {
		log.Fatal("localhost isn't localhost")
	}

}
