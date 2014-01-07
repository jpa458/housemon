#typedef struct { int power; int voltage; int battery } PayloadTX;
#OK 5 29 8 240 0 192 12 null
module.exports = (app) ->
  app.register 'driver.emontxNode',
    announcer: 5
    in: 'Buffer'
    out:
      power:
        title: 'Power', unit: 'W', min: 0, max: 30000
      voltage:
        title: 'Volts', unit: 'V', min: 0, max: 260
      current:
        title: 'Current', unit: 'A', min: 0, max: 100
      battery:
        title: 'Battery', unit: 'mV', min: 0, max: 6000
    decode: (data) ->
      raw = data.msg
      p = raw.readUInt16LE(1)
      v = raw.readUInt16LE(3)
      c = (p / v).toFixed(2)
      b = raw.readUInt16LE(5)
      { power: p, voltage: v, current: c, battery: b }