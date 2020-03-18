#!/bin/sh

xset fp rehash
xset dpms 120 300 600
xset s off
xset b off

autocutsel -fork
autocutsel -selection PRIMARY -fork

/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

exec i3
