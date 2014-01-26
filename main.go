package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/jcw/jeebus"
)

func main() {
	if len(os.Args) <= 1 {
		log.Fatalf("usage: housemon <cmd> ...")
	}

	switch os.Args[1] {

	case "decode":
		var rdClient jeebus.Client
		rdClient.Connect("rd")
		rdClient.Register("RF12demo/#", &RF12demoDecodeService{})
		<-make(chan byte) // wait forever

	default:
		log.Fatal("unknown sub-command: housemon ", os.Args[1], " ...")
	}
}

type RF12demoDecodeService struct {
}

func (s *RF12demoDecodeService) Handle(m *jeebus.Message) {
	// log.Println("RF12", m)
	text := m.Get("text")
	if strings.HasPrefix(text, "[RF12demo.") {
		fmt.Println(text)
	}
	if strings.HasPrefix(text, "OK ") {
		fmt.Println(text)
	}
}
