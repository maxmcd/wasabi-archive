package main

import (
	"crypto/rand"
	"fmt"
	"time"
	// "github.com/maxmcd/wasm-servers/gowasm"
)

func main() {
	foo := time.Now()
	fmt.Println("does this work?", foo)

	byt := make([]byte, 10)
	_, err := rand.Read(byt)
	if err != nil {
		panic(err)
	}
	fmt.Println(byt)
	go func() {
		fmt.Println("within a goroutine")
	}()
	// testSetGetenv()
	// testHTTP()
	// time.Sleep(time.Millisecond * 5)
	//
	fmt.Println("after sleep")

}

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
