package gowasm

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"net/http/httptest"
	"testing"
)

func init() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}

func TestGetRandomData(t *testing.T) {
	b := make([]byte, 10)
	GetRandomData(b)
	if bytes.Equal(make([]byte, 10), b) {
		t.Error("Bytes should not be 0s")
	}
}

func TestSetGetenv(t *testing.T) {
	Setenv("something", "value")
	val, ok := Getenv("something")
	if ok != true {
		t.Error("ok should be true for getenv")
	}
	if val != "value" {
		t.Error("should have value for getenv")
	}
	val, ok = Getenv("something-else")
	if ok != false {
		t.Error("no value should be present for getenv")
	}
	if val != "" {
		t.Error("also shouldn't have the value")
	}
}

func TestLookupAddr(t *testing.T) {
	names, err := LookupAddr("127.0.0.1")
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

func TestInternalHttp(t *testing.T) {
	s := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("ok"))
	}))

	resp, err := http.Get(s.URL)
	if err != nil {
		t.Error(err)
	}
	if resp.StatusCode != http.StatusOK {
		t.Error("Wrong status code", resp.StatusCode)
	}
}

func TestHttp(t *testing.T) {
	resp, err := http.Get("https://www.google.com")
	fmt.Println(resp, err)
}

// Doesn't seem to work with exec...
func BenchmarkEnv(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Setenv("something", "value")
		_, _ = Getenv("something-else")
	}
}
