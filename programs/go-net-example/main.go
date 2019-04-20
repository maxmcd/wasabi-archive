package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"

	"github.com/maxmcd/wasabi"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	go func() {
		time.Sleep(time.Second * 2)
		start := time.Now()
		// for i := 0; i < 2; i++ {
		for {

			if _, err := httpGet("http://localhost:8080/"); err != nil {
				log.Fatal(err)
			} else {
				// resp.Body.Close()
				time.Sleep(time.Millisecond)
			}
		}
		fmt.Println(
			"Each network request took on average: ",
			time.Now().Sub(start)/1000)
		runtime.GC()
		os.Exit(0)
	}()

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.Method, r.URL.String(), time.Now())
		w.Write([]byte("Hello World"))
	})
	fmt.Println("listening on 127.0.0.1:8080")
	log.Fatal(wasabi.ListenAndServe("127.0.0.1:8080", handler))
}

func httpGet(url string) (*http.Response, error) {
	client := http.Client{Transport: &wasabi.RoundTripper{}}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	return client.Do(req)
}
