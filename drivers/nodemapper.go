package drivers

import (
	//"github.com/jcw/jeebus"
	//"strings"
	//"strconv"
	"fmt"
	"log"
	"encoding/json"
	"os"
	//"bytes"
)

//type RF12NodeDecodeService struct {
//}
//
//func (s *RF12NodeDecodeService) Handle(m *jeebus.Message) {
//	text := m.Get("text")
//	if strings.HasPrefix(text, "OK ") {
//		var buf bytes.Buffer
//		// convert the line of decimal byte values to a byte buffer
//		for _, v := range strings.Split(text[3:], " ") {
//			n, err := strconv.Atoi(v)
//			check(err)
//			buf.WriteByte(byte(n))
//		}
//		now := m.GetInt64("time")
//		dev := strings.SplitN(m.T, "/", 2)[1]
//		fmt.Printf("%d %s %X\n", now, dev, buf.Bytes())
//	}
//}

type NodeMapEntry struct {
	G    int
	N    int
	Ts     int
	Te     int
	Type  string
	Name string
}

type NodeMapT struct {
	NodeMap []NodeMapEntry
}

var nMap *NodeMapT

func JNodeMap () {
	file, e := os.Open("./nodemap.json")
	check(e)
	//fmt.Printf("%s\n", string(file))

	decoder := json.NewDecoder(file)
	//nMap := &NodeMapT{}
	decoder.Decode(&nMap)
	//fmt.Printf("Results: %v\n", nMap)
}

func JNodeType(G, N int) (bool, string, string) {
	for _, node := range nMap.NodeMap {
		if node.G == G && node.N == N {
			fmt.Println("found rf12 node: ", node.Type)
			return true, node.Type, node.Name
		}
	}
	return false, "", ""
}

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
