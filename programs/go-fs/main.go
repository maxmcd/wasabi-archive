package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

// fmt.Println(syscall.O_RDONLY) 0
// fmt.Println(syscall.O_WRONLY) 1
// fmt.Println(syscall.O_RDWR) 2
// fmt.Println(syscall.O_CREAT) 64
// fmt.Println(syscall.O_CREATE) 64
// fmt.Println(syscall.O_TRUNC) 512
// fmt.Println(syscall.O_APPEND) 1024
// fmt.Println(syscall.O_EXCL) 128
// fmt.Println(syscall.O_SYNC) 4096
// fmt.Println(syscall.O_CLOEXEC) 0

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
