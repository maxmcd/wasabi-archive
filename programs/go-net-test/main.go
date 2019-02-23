package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"
)

const REQUEST_COUNT = 1000

func main() {
	toRun := os.Args[1:]

	cmd := exec.Command(toRun[0], toRun[1:]...)
	cmd.Stderr = os.Stderr
	r, w, _ := os.Pipe()
	cmd.Stdout = w
	cmd.Start()

	rd := bufio.NewReader(r)
	readyChan := make(chan bool)
	go func() {
		started := false
		for {
			line, _, err := rd.ReadLine()
			if err != nil {
				panic(err)
			}
			if !started && strings.Contains(string(line), "listening") {
				readyChan <- true
				started = true
			}
			fmt.Println(string(line))
		}
	}()

	<-readyChan
	fmt.Println("started")
	start := time.Now()
	go func() {
		for l := 0; l < REQUEST_COUNT; l++ {
			_, err := http.Get("http://localhost:8482")
			if err != nil {
				panic(err)
			}
		}
	}()
	for l := 0; l < REQUEST_COUNT; l++ {
		_, err := http.Get("http://localhost:8482")
		if err != nil {
			panic(err)
		}
	}
	fmt.Println(time.Now().Sub(start) / REQUEST_COUNT)

	cmd.Process.Signal(os.Kill)
}
