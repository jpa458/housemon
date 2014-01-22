package main

import (
	"log"
  "os"

	"github.com/jcw/jeebus"
)

func main() {
  switch jeebus.SubCommand("housemon") {
  // no extra sub-commands defined yet
  default:
		log.Fatal("unknown sub-command: housemon ", os.Args[1], " ...")
	}
}
