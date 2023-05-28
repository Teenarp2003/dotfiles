#!/usr/bin/env sh

# Terminate already running bar instances and env programs
killall -q polybar dunst lxpolkit glava  
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

#Nitrogen
~/.fehbg
# Launch picom
picom --animations -b
# Launch
polybar top &
echo "Bar launched..."
