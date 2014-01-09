#struct {int16_t temperature;} payload;
module.exports = (app) ->
  app.register 'driver.emonLCD',
    announcer: 110
    in: 'Buffer'
    out:
      temp:
        title: 'Temperature', unit: 'C', min: -50, max: 50, scale: 2
    decode: (data) ->
      raw = data.msg
      t = raw[2] * 256
      t = t + raw[1]
      { temp: t }