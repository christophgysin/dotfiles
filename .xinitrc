xset +fp /usr/share/fonts/local
xset fp rehash
#xset dpms 60 120 180
xset -dpms
setxkbmap -layout fi -variant mac
xset b off

autocutsel -fork
autocutsel -selection PRIMARY -fork

xrandr --dpi 192
xrandr | grep -q "DP-2 connected" && outputs dual

exec i3
