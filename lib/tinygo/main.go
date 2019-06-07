package main

import (
	"encoding/json"
	"fmt"
)

func main() {

	requestData := `POST / HTTP/1.1
Host: 127.0.0.1:52587
Accept-Encoding: gzip
Content-Length: 4
Content-Type: text/plain
User-Agent: Go-http-client/1.1

DATA`

	fmt.Println(requestData)

	thing := map[string]string{
		"hi":           "ho",
		"sad":          "ho",
		"hasasi":       "ho",
		"hasdffi":      "ho",
		"hasdddffi":    "ho",
		"hasdfadsfi":   "ho",
		"hasfffdddffi": "ho",
		"hasdfdffi":    "ho",
		"hadsdffi":     "ho",
	}
	fmt.Println(thing["hi"])

	fmt.Println(json.Marshal(&thing))
}
