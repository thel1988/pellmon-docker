PellMon
=======
![logo](https://raw.github.com/motoz/PellMon/master/src/Pellmonweb/media/img/favicon-160x160.png)

This docker Container is a clone Pellmon application so it is runable from a docker container
Which also support mqtt forwarding, in my instance to my Hassio instance
Plus a try to reconnect

This docker container have the following variables which can be set
##### Default Variables
```
loglevel=info 
webport=8081 
webuser=testuser
webpass=12345 
nbeserial=0 
nbepass=notinuseithink 
mqtthost=localhost 
mqttport=1883 
mqtttopic=pellmon
mqttuser=user
mqttpass=pass
```