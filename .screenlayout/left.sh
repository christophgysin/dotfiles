#!/bin/sh
xrandr \
  --output eDP-1 --scale 0.5x0.5 --mode 2560x1600 --pos 0x1208 --rotate normal \
  --output DP-1 --off \
  --output DP-2 --primary --mode 3840x1600 --pos 1280x0 --rotate normal \
  --output HDMI-1 --off \
  --output HDMI-2 --off \

