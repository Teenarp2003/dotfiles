#!/bin/sh
MODULE_OPTIONS="devices=3 video_nr=2 exclusive_caps=1 card_label=cam_2"
rmmod v4l2loopback 2> /dev/null
modprobe videodev
insmod ./v4l2loopback.ko ${MODULE_OPTIONS}
scrcpy --video-source=camera --camera-size=1920x1080 --camera-facing=back  --camera-fps=60 --v4l2-sink=/dev/video2 --no-playback
