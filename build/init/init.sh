#!/bin/bash
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