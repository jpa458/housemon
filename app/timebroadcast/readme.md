Time Broadcast Briq

This briq is a basic implementation to allow broadcast of the current time at a user definable interval.

The purpose of this is to update the time on remote nodes, that have a Real Time Clock (RTC) function.

The packet is 4 bytes in the standard RF12 broadcast. 116, hh, mm, ss

Currently the briq simply echos the command on to the serial device specified. Which should be the same as the Jeelink used.

On the master (0.8) branch, it is necessary to add the following lines to the host file in app/main:
 - Under app.on 'running', ->
          TimeBroadcast = @registry.source.timebroadcast
 - Then 
          timebroadcast = new TimeBroadcast
This instantiates the default settings. Else you should use timebroadcast = new TimeBroadcast device, period
