#description: 'This Briq sends a periodic time packet to update remote nodes'
exec = require('child_process').exec

class TimeBroadcast
  constructor: (@device = 'dev/ttyUSB0', @period = 20) ->
    @period = @period * 1000
    @interval = setupInterval @device, @period
    console.info "TimeBroadcast App Setup - Start Time Broadcast: #{@device}, #{@period}"
    
  setupInterval = (device, period) ->
    interval = setInterval ( ->
      sendTime device
      ), period
    return interval
    
  sendTime = (device) ->
    d = new Date
    h = d.getHours()
    m = d.getMinutes()
    s = d.getSeconds()
       
    exec "echo 116,#{h},#{m},#{s},s > #{device}", (err, stdout, stderr) ->
      if err
        console.log "exec child process exited, #{device}, error code " + err.code
    
module.exports = (app, plugin) ->
  app.register 'source.timebroadcast', TimeBroadcast
