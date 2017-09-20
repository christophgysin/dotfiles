#!/bin/sh
xrandr \
  --output DP-2 --auto --pos 0x0 --primary \
  --output eDP-1 --auto --scale 0.5x0.5 --pos 1680x536 \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output HDMI-2 --off \

