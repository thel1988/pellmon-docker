FROM debian:buster-slim

WORKDIR /opt/pellmon

RUN apt-get update && apt-get install -y \
    rrdtool \
    autoconf \
    python-pip \
    pkg-config \
    supervisor \
    libglib2.0-dev \
    python-dev \
    libdbus-1-dev \
    libcairo2-dev \
    python-gobject

RUN pip install pycairo pyownet xtea paho-mqtt ws4py argcomplete crypto python-dateutil simplejson mako dbus-python CherryPy pyserial 

ADD pellmonMQTT.py /opt/
ADD pellmon.v0.7.0.tar.gz .

RUN ls -l && cd PellMon-0.7.0 && ./autogen.sh && ./configure --enable-debug --sysconfdir=/etc && make && make install

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD build/confd/*.conf /etc/pellmon/conf.d/
ADD build/conf/pellmon.conf /etc/pellmon/pellmon.conf
ADD build/plugins/*.conf /etc/pellmon/conf.d/plugins/
ADD build/init/init.sh /opt/init.sh

RUN mkdir -p /var/log/supervisor/ \
    /var/run/pellmonsrv/ \
    /var/run/pellmonweb/ \
    /var/run/dbus/ \ 
    /usr/local/var/ \ 
    /usr/local/var/lib/ \
    /usr/local/var/lib/pellmon/ \
    /usr/local/var/log/pellmonsrv/ \
    && touch /usr/local/var/log/pellmonsrv/pellmon.log 

ENV loglevel=info webport=8081 webuser=testuser webpass=12345 nbeserial=0 nbepass=notinuseithink mqtthost=localhost mqttport=1883 mqtttopic=pellmon

VOLUME ["/usr/local/var/lib/pellmon/", "/usr/local/var/log/"]

ENTRYPOINT ["/opt/init.sh"]

EXPOSE 8081