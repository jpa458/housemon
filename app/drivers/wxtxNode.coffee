#struct {int light; int humidity; int temperature; int dewpoint; int cloudbase; int vcc;} payload;
module.exports = (app) ->
  app.register 'driver.wxtxNode',
    announcer: 18
    in: 'Buffer'
    out:
      light:
        title: 'Light intensity', unit: '%', min: 0, max: 100, scale: 0
      humi:
        title: 'Relative humidity', unit: '%', min: 0, max: 100, scale: 1
      temp:
        title: 'Temperature', unit: 'C', min: -50, max: +50, scale: 1
      dewpoint:
        title: 'Dewpoint', unit: 'C', min: -50, max: 50
      cloudbase:
        title: 'Cloudbase', unit: 'Ft', min: -1000, max: 50000
      battery:
        title: 'Battery', unit: 'mV', min: '0', max: '5000'
    decode: (data) ->
    #int light; int humidity; int temperature; int dewpoint; int cloudbase; int vcc;} payload;
      #OK 18 100 0 151 2 187 0 12 0 120 10 179 11 null
      raw = data.msg
      l = raw.readUInt16LE(1)
      h = raw.readUInt16LE(3)
      t = raw.readUInt16LE(5)
      d = raw.readUInt16LE(7)
      c = raw.readUInt16LE(9)
      b = raw.readUInt16LE(11)
      { light: l, humi: h, temp: t, dewpoint: d, cloudbase: c, battery: b }