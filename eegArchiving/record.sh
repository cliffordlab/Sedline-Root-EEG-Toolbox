#!/bin/bash
cat </dev/tcp/time.nist.gov/13 >> ~/rectime.txt
lxterminal -e arecord -D plughw:1 -f S16_LE -vv ~/rec-23Aug-10am.wav
cat </dev/tcp/time.nist.gov/13 >>~/rectime.txt
