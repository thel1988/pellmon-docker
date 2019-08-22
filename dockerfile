FROM debian:stable-slim

ADD https://github.com/motoz/PellMon/releases/download/v0.7.0/pellmon_0.7.0-1_all.deb /
RUN mkdir -p /opt/pellmonmqtt
ADD https://github.com/motoz/pellmonMQTT/blob/master/pellmonMQTT.py /opt/pellmonmqtt

ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    rrdtool \
    python-serial \
    python-cherrypy3 \
    python-dbus \
    python-mako \
    python-gobject \
    python-simplejson \
    python-dateutil \
    python-ws4py \
    python-crypto \
    autoconf \
    python-argcomplete \
    python-pip \
    supervisor
RUN dpkg -i /pellmon_0.7.0-1_all.deb
RUN pip install pyownet
RUN pip install xtea
RUN pip install simplejson
RUN pip install paho-mqtt
RUN mkdir -p /var/log/supervisor

EXPOSE 8081
VOLUME ["/etc/pellmon", "/var/lib/pellmon"]

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD build/confd/*.conf /etc/pellmon/conf.d/
ADD build/plugins/*.conf /etc/pellmon/conf.d/plugins/
ADD build/init/init.sh /root/init.sh

ENTRYPOINT ["/init.sh"]