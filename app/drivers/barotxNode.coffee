#struct {byte light; int16_t barometricTemperature; int32_t barometricPressure; int battery;} payload;
module.exports = (app) ->
  app.register 'driver.barotxNode',
    announcer: 17
    in: 'Buffer'
    out:
      light:
        title: 'Light level', unit: '%', min: 0, max: 255, factor: 100 / 255, scale: 0
      temp:
        title: 'Temperature', unit: 'C', min: -50, max: +50, scale: 1
      pres:
        title: 'Pressure', unit: 'hPA', min: 0, max: 2000, scale: 2
      battery:
        title: 'Battery', unit: 'mV', min: '0', max: '5000'
    decode: (data) ->
      raw = data.msg
      #OK 17 255 232 0 179 144 1 0 108 12 null
      { light: raw[1], temp: raw.readUInt16LE(2), pres: raw.readUInt32LE(4), battery: raw.readUInt16LE(8) }