package main

import (
	"crypto/rand"
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	b := make([]byte, 10)
	_, err := rand.Read(b)
	if err != nil {
		panic(err)
		return
	}
	// The slice should now contain random bytes instead of only zeroes.
	fmt.Println(b)
	fmt.Println("hello")

	fi, err := os.Stat("/")
	fmt.Println(fi, err)
	fmt.Println(os.Getwd())
	fmt.Println(os.Mkdir("/foo", 0755))
	fmt.Println(os.Chdir("/foo"))
	fmt.Println(os.Getwd())
	file, err := os.Create("/foo/bar")
	fmt.Println(file.Write([]byte("something")))
	bytes, err := ioutil.ReadFile("/foo/bar")
	fmt.Println(string(bytes), err)
}
