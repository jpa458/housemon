package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"strconv"
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
	text := m.Get("text")
	if strings.HasPrefix(text, "OK ") {
		var buf bytes.Buffer
		// convert the line of decimal byte values to a byte buffer
		for _, v := range strings.Split(text[3:], " ") {
			n, err := strconv.Atoi(v)
			check(err)
			buf.WriteByte(byte(n))
		}
		now := m.GetInt64("time")
		dev := strings.SplitN(m.T, "/", 2)[1]
		fmt.Printf("%d %s %X\n", now, dev, buf.Bytes())
	}
}

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
