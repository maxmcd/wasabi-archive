package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
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
