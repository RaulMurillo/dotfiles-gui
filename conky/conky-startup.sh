#!/bin/sh

killall conky
sleep 10s

conky -c "$HOME/.conky/panel/conkyrc" &> /dev/null &
exit 0
