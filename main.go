package main

import (
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/jcw/jeebus"
)

const LOGGER_PATH_FMT = "./logger/%d"

var currentLogFile *os.File

func main() {
	if len(os.Args) <= 1 {
		log.Fatalf("usage: housemon <cmd> ...")
	}

	switch os.Args[1] {

	case "logger":
		logger()

	default:
		log.Fatal("unknown sub-command: housemon ", os.Args[1], " ...")
	}
}

func logger() {
	for msg := range jeebus.ConnectToServer("rd/#") {
		text := msg.Get("text")
		now := time.Now().UTC()
		datePath := dateFilename(now)
		if currentLogFile == nil || datePath != currentLogFile.Name() {
			if currentLogFile != nil {
				currentLogFile.Close()
			}
			mode := os.O_WRONLY | os.O_APPEND | os.O_CREATE
			fd, err := os.OpenFile(datePath, mode, os.ModePerm)
			if err != nil {
				log.Fatal(err)
			}
			currentLogFile = fd
		}
		// L 01:02:03.537 usb-A40117UK OK 9 25 54 66 235 61 210 226 33 19
		h, m, s := now.Clock()
		port := strings.SplitN(msg.T, "/", 3)[2]
		line := fmt.Sprintf("L %02d:%02d:%02d.%03d %s %s\n",
			h, m, s, now.Nanosecond()/1000000, port, text)
		currentLogFile.WriteString(line)
	}
}

func dateFilename(now time.Time) string {
	year, month, day := now.Date()
	path := fmt.Sprintf(LOGGER_PATH_FMT, year)
	os.MkdirAll(path, os.ModePerm)
	// e.g. "./logger/2014/20140122.txt"
	return fmt.Sprintf("%s/%d.txt", path, (year*100+int(month))*100+day)
}
