dunst_status=$(dunstctl is-paused)

notif_off=(notify-send.sh -t 1000 --print-id --replace=10 "Focus Mode OFF")
notif_on=(notify-send.sh -t 1000 --print-id --replace=10 "Focus Mode ON")
dunst_toggle=(dunstctl set-paused toggle)

if [[ "$dunst_status" == "false" ]]; then
  "${notif_on[@]}"
  sleep 0.5s
  "${dunst_toggle[@]}"
else
  "${notif_off[@]}"
  sleep 0.2s
  "${dunst_toggle[@]}"
fi

