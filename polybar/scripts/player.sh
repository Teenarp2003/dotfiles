#!/bin/sh

player_status=$(playerctl -p spotify status 2> /dev/null)
song_name=$(playerctl -p spotify metadata title --no-messages)
song_name_mod=${song_name:0:12}"..."
song_name_set=$(playerctl -p spotify metadata title --no-messages |wc -w )

artist_name=$(playerctl -p spotify metadata artist --no-messages)
artist_name_len=$(playerctl -p spotify metadata artist --no-messages | wc -c)
artist_name_mod=$(playerctl -p spotify metadata artist --no-messages| head -n1 | awk '{print $1;}')

if [ "$song_name_set" -gt "2" ]; then
  song_name_disp=${song_name_mod}
else
  song_name_disp=${song_name}
fi

if [ "$artist_name_len" -gt "10" ]; then
  artist_name_disp=${artist_name_mod}
else
  artist_name_disp=${artist_name}
fi

if [ "$player_status" = "Playing" ]; then
  echo "${artist_name_disp}  ${song_name_disp}"
elif [ "$player_status" = "Paused" ]; then
  echo "${artist_name_disp}  ${song_name_disp}"
else
    echo ""
fi
