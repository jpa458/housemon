package drivers

import (
	"strconv"
	"fmt"
	"bytes"
	"encoding/hex"
	"encoding/binary"

	"github.com/jcw/jeebus"
)

type RoomNode struct {
	NID         uint8		`json:"-"`
	//Seq         uint8		`json:"seq"`
	Light       uint8		`json:"light"`
	HumiM       uint8		`json:"humim"`
	Temp        int16		`json:"temp"`
}

type RoomNodeDecoder struct {
}

func (s *RoomNodeDecoder) Handle(m *jeebus.Message) {
	b, err := hex.DecodeString(m.Get("text"))
	check(err)
	var v RoomNode
	err = binary.Read(bytes.NewReader(b), binary.LittleEndian, &v)
	check(err)
  if v.Temp >= 0x200 {
    v.Temp -= 0x400
  }
  moved := v.HumiM & 1
  v.HumiM = v.HumiM >> 1 
	fmt.Println(v)
  prefix := "/hm/"+m.Get("loc")+"/roomnode/"
  postfix := "/"+strconv.FormatInt(m.GetInt64("time") ,10)
	//jeebus.Publish(prefix+"seq"+postfix, v.Seq)
	jeebus.Publish(prefix+"light"+postfix, v.Light)
	jeebus.Publish(prefix+"humi"+postfix, v.HumiM)
	jeebus.Publish(prefix+"moved"+postfix, moved)
	jeebus.Publish(prefix+"temp"+postfix, v.Temp)
}

func init() {
	rf12Client := jeebus.NewClient("rf12")
	rf12Client.Register("roomnode/#", &RoomNodeDecoder{})
}
