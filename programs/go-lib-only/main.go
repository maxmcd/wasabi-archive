package main

import (
	"crypto/rand"
	"fmt"
	"time"
)

// "github.com/maxmcd/wasm-servers/gowasm"
// "github.com/maxmcd/wasm-servers/gowasm/http"

func main() {
	foo := time.Now()
	_ = foo
	fmt.Println("does this work?")

	byt := make([]byte, 10)
	_, err := rand.Read(byt)
	if err != nil {
		panic(err)
	}
	fmt.Println(byt)

	time.Sleep(time.Millisecond * 40)
	// testGetRandomData()
	// testSetGetenv()
	// testHTTP()
}

// func testGetRandomData() {
// 	b := make([]byte, 10)
// 	gowasm.GetRandomData(b)
// 	if bytes.Equal(make([]byte, 10), b) {
// 		panic("Bytes should not be 0s")
// 	}
// }

// func testSetGetenv() {
// 	gowasm.Setenv("something", "value")
// 	val, ok := gowasm.Getenv("something")
// 	if ok != true {
// 		panic("ok should be true for getenv")
// 	}
// 	if val != "value" {
// 		panic("should have value for getenv")
// 	}
// 	val, ok = gowasm.Getenv("something-else")
// 	if ok != false {
// 		panic("no value should be present for getenv")
// 	}
// 	if val != "" {
// 		panic("also shouldn't have the value")
// 	}
// }

// func testHTTP() {
// 	resp, err := http.Get("https://www.google.com")
// 	time.Sleep(time.Second * 1)
// 	if err != nil {
// 		panic(err)
// 	}
// 	fmt.Println(resp)
// }
