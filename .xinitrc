xset +fp /usr/share/fonts/local
xset fp rehash
xset dpms 600 1200 1800
setxkbmap ch
xset b off

xrandr | grep -q "DP-1 connected" && outputs dual

exec i3
