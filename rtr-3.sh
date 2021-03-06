#!/bin/sh
sudo kill -9 `pidof java`
sudo kill -9 `pidof socat`
sudo kill -9 `pidof rtr.bin`
sudo kill -9 `pidof rawInt.bin`
sudo kill -9 `pidof pcapInt.bin`
sudo ifconfig eth0 promisc up
sudo socat tcp4-listen:21002,reuseaddr file:/dev/ttyS0,sane,b9600,cs8,raw,echo=0,crtscts=0&
sudo socat INTERFACE:eth0 UDP4-DATAGRAM:127.0.0.1:22706,bind=127.0.0.1:22705,reuseaddr&
java -jar src/rtr.jar routerc rtr-
