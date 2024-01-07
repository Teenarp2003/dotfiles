#!/bin/sh
get_layout=$(bsp-layout get)
notify-send.sh -t 1500  --replace=10 "LAYOUT:" "$get_layout"
