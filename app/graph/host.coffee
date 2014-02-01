Q = require 'q'

module.exports = (app, plugin) ->  
  app.on 'setup', ->
  	console.log 'graph setup'

  	app.host.status_driverinfo = ->
      app.registry.driver

    readValues = (params, cb) ->
      keys = params.split '/'
      prefix = "reading~"+keys[0]+"~"+keys[1]
      result = []
      app.db.createReadStream
        start: prefix + '~'
        end: prefix + '~~'
        valueEncoding: 'json'
      .on 'data', (data) ->
        if data.value[keys[2]]
          t = data.key.split '~'
          result.push [+t[3],data.value[keys[2]]]
      .on 'end', ->
        rowInfo = app.registry.driver[keys[0]]?.out
        rowInfo = rowInfo?[keys[2]] ? {}
      
        for rec in result
          if rowInfo.factor
            rec[1] *= rowInfo.factor
          if rowInfo.scale < 0
            rec[1] *= Math.pow 10, -rowInfo.scale
          else if rowInfo.scale >= 0
            rec[1] /= Math.pow 10, rowInfo.scale
            rec[1] = rec[1].toFixed rowInfo.scale  
        cb result   

    app.host.graphData = (params) ->
      q = Q.defer()
      readValues params, q.resolve
      q.promise
