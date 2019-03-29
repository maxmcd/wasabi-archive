package main

import (
	"fmt"

	"github.com/maxmcd/wasabi"
)

// https://github.com/ctz/webpki-roots/blob/master/src/lib.rs
// https://golang.org/src/crypto/x509/root_unix.go
// func httpGet(url string) (*http.Response, error) {
// 	client := http.Client{Transport: &wasabi.RoundTripper{}}
// 	req, err := http.NewRequest("GET", url, nil)
// 	if err != nil {
// 		return nil, err
// 	}
// 	return client.Do(req)
// }

func main() {
	fmt.Println("hi")
	fmt.Println("hi")
	fmt.Println("hi")
	fmt.Println("hi")
	fmt.Println("hi")
	fmt.Println(wasabi.LookupIP("www.google.com"))
	fmt.Println(wasabi.LookupIP("ogle.comgle"))
	// httpGet("https://www.google.com")
}
