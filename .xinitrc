#!/bin/sh

#xset +fp /usr/share/fonts/local
xset fp rehash
xset dpms 120 300 600
#xset -dpms
xset s off
xset b off

#setxkbmap -layout fi -variant mac

autocutsel -fork
autocutsel -selection PRIMARY -fork

if [ "$(</sys/class/drm/card0-DP-2/status)" == connected ]; then
    #outputs ext
    :
else
    export ELM_SCALE=1.5
    export GDK_SCALE=2
    export GDK_DPI_SCALE=0.5
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    xrandr --dpi 192
fi

/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

exec i3
