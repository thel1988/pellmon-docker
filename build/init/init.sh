#!/bin/bash

sed -i -r "s/^loglevel.*/loglevel = ${loglevel}/g" /etc/pellmon/pellmon.conf
sed -i -r "s/^port.*/port = ${webport}/g" /etc/pellmon/conf.d/webinterface.conf
sed -i -r "s/^testuser.*/${webuser} = ${webpass}/g" /etc/pellmon/conf.d/webinterface.conf
sed -i -r "s/^serial.*/serial = ${nbeserial}/g" /etc/pellmon/conf.d/plugins/nbecom.conf
sed -i -r "s/^password.*/password = ${nbepass}/g" /etc/pellmon/conf.d/plugins/nbecom.conf
sed -i -r "s|pellmonMQTT.py.*|pellmonMQTT.py -H ${mqtthost} -p ${mqttport} -t '${mqtttopic}' -u '${mqttuser}' -P '{$mqttpass}' -d SYSTEM\"|g" /etc/supervisor/conf.d/supervisord.conf

rm /run/dbus/pid

CONTAINER_ALREADY_STARTED="/tmp/CONTAINER_ALREADY_STARTED"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup initializing --"
    dbus-uuidgen > /var/lib/dbus/machine-id
    mkdir -p /var/run/dbus
    /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
else
    echo "-- Starting up normal --"
    /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
fi
