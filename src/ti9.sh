#!/bin/sh
java -Xmx256m -jar rtr.jar test tester intop9- remote intop9.ini summary retry url http://sources.nop.hu/cfg/ randord $1 $2 $3 $4 $5 $6 $7 $8
