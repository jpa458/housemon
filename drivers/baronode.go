package drivers

import (
	"strconv"
	"fmt"
	"bytes"
	"encoding/hex"
	"encoding/binary"

	"github.com/jcw/jeebus"
)

type BaroNode struct {
	NID       uint8		`json:"-"`
	Seq       uint8		`json:"seq"`
	MsgT      uint8		`json:"-"`
	Temp      uint16    `json:"temp"`
	Pres      uint32    `json:"pres"`
}

type BaroNodeDecoder struct {
}

func (s *BaroNodeDecoder) Handle(m *jeebus.Message) {
	b, err := hex.DecodeString(m.Get("text"))
	check(err)
	var v BaroNode
	err = binary.Read(bytes.NewReader(b), binary.LittleEndian, &v)
	check(err)
	fmt.Println(v)
  prefix := "/hm/"+m.Get("loc")+"/baronode/"
  postfix := "/"+strconv.FormatInt(m.GetInt64("time") ,10)
  //postfix := "/"+m.Get("time")
	jeebus.Publish(prefix+"seq"+postfix, v.Seq)
	jeebus.Publish(prefix+"temp"+postfix, v.Temp)
	jeebus.Publish(prefix+"pres"+postfix, v.Pres)

	//now := m.GetInt64("time")
}

func init() {
	rf12Client := jeebus.NewClient("rf12")
	rf12Client.Register("baronode/#", &BaroNodeDecoder{})
}
