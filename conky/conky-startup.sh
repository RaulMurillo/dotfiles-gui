#!/bin/sh

killall conky
sleep 5s

conky -c "$HOME/.conky/panel/conkyrc.conf" &> /dev/null &
exit 0
