#!/bin/sh
./d.sh
javac -source 8 -target 8 -Xlint:all -deprecation *.java
