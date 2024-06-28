#!/bin/bash
mem=$(free -m | awk '{ print $3 }' | awk 'NR==2')
deco="<span font_family='Iosevka Nerd Font' color='#ff9e64' size='small'></span> "
deco1=""
decoend=" MB"
op=$deco$mem$decoend
echo $op
