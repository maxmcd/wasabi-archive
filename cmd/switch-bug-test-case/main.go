package main

import (
	"fmt"
	"log"
)

func main() {
	net := "tcp"
	switch net {
	case "tcp", "tcp4", "tcp6", "udp", "udp4", "udp6":
		fmt.Println("Should match")
	case "ip", "ip4", "ip6":
		fmt.Println("shouldn't match")
	default:
		log.Fatal("broken")
	}
}
