#!/bin/bash
FILE="/home/teenarp2026/.cache/wal/theme.conf"
wal="$(cat ~/.cache/wal/wal)"
TEXT="Background=$wal"
sed -i "3s|.*|$TEXT|" $FILE
echo "replaced theme.conf with path"

