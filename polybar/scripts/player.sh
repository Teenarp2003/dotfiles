#!/bin/sh
player_list=($(playerctl -l))
def_player=${player_list[0]}
player_on=""

for player in "${player_list[@]}"; do
    status=$(playerctl -p "$player" status)
    if [ "$status" == "Playing" ]; then
        player_on="$player"
        break
    elif [ "$status" == "Paused" ]; then
        player_on=""
    fi
done

if [ -z "$player_on" ]; then
    player_f=$def_player
else
    player_f=$player_on
fi

player_status=$(playerctl -p "$player_f" status 2> /dev/null)
song_name=$(playerctl -p "$player_f" metadata title --no-messages)
song_name_mod=${song_name:0:9}"..."
song_name_set=$(echo "$song_name" | wc -w)

artist_name=$(playerctl -p "$player_f" metadata artist --no-messages)
artist_name_len=$(echo "$artist_name" | wc -c)
artist_name_mod=$(echo "$artist_name" | head -n1 | awk '{print substr($1, 1, 5)}')

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

if [[ "$player_status" = "Playing" || "$player_status" = "Stopped" ]]; then
    echo "${artist_name_disp}%{T7}  %{T-}%{T4} ${song_name_disp} %{T-}"
elif [ "$player_status" = "Paused" ]; then
    echo "${artist_name_disp}%{T7}  %{T-}%{T4} ${song_name_disp}%{T-}"
else
    echo ""
fi

