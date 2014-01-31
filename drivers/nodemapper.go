package drivers

import (
	"fmt"
	"log"
	"encoding/json"
	"os"
)

type NodeMapEntry struct {
	G      int
	N      int
	Ts     int64
	Te     int64
	Type   string
	Name   string
}

type NodeMapT struct {
	NodeMap []NodeMapEntry
}

var nMap *NodeMapT

func jNodeMap() {
	file, e := os.Open("./nodemap.json")
	check(e)
	decoder := json.NewDecoder(file)
	decoder.Decode(&nMap)
	//fmt.Printf("Results: %v\n", nMap)
}

func JNodeType(G, N int, TS int64) (bool, string, string) {
	for _, node := range nMap.NodeMap {
		if node.G == G && node.N == N && TS >= node.Ts && (TS < node.Te || node.Te <= node.Ts) {
			fmt.Println("found rf12 node: ", node.Type)
			return true, node.Type, node.Name
		} else {
		}
	}
	return false, "", ""
}

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func init() {
	jNodeMap()
}
