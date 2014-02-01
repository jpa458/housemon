Q = require 'q'

module.exports = (app, plugin) ->  
  app.on 'setup', ->
  	console.log 'dashboard setup'
