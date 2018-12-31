package http

import (
	"encoding/json"
	"fmt"
	"net/http"
	"testing"
)

func TestRoundtrip(t *testing.T) {
	url := "http://localhost"
	resp, err := Get(url)
	if err != nil {
		t.Error(err)
	}
	fmt.Println(resp)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		t.Error(err)
	}
	reqBytes, err := json.Marshal(req)
	if err != nil {
		t.Error(err)
	}
	println(string(reqBytes))

}
