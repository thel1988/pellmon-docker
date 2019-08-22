FROM debian:jessie-slim

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
    python-crypto \
    autoconf \
    python-ws4py \
    python-argcomplete \
    python-pip \
    supervisor
RUN pip install pyownet
RUN pip install xtea
RUN pip install simplejson
RUN pip install paho-mqtt
VOLUME ["/etc/pellmon", "/var/lib/pellmon"]
RUN dpkg -i /pellmon_0.7.0-1_all.deb
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/pellmonsrv/
RUN mkdir -p /var/run/pellmonweb/
EXPOSE 8081
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD build/confd/*.conf /etc/pellmon/conf.d/
ADD build/conf/pellmon.conf /etc/pellmon/pellmon.conf
ADD build/plugins/*.conf /etc/pellmon/conf.d/plugins/
ADD build/init/init.sh /root/init.sh
RUN chmod +x /root/init.sh
ENTRYPOINT ["/root/init.sh"]