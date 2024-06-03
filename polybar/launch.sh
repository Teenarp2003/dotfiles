#!/usr/bin/env sh

# Terminate already running bar instances and env programs
killall polybar 
killall fusuma 
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done
while pgrep -x fusuma >/dev/null; do sleep 1; done

#Nitrogen
~/.fehbg
# Launch picom
picom --animations -b
# Launch
polybar top &
echo "Bar launched..." &
fusuma
