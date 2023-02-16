#!/usr/bin/env python

import os

BAR = "▁▂▃▄▅▆▇█"

# Creating a mapping to replace each character with its corresponding bar character
char_to_bar = {str(i): BAR[i] for i in range(len(BAR))}
translator = str.maketrans(char_to_bar)

# Create a named pipe (FIFO)
pipe = "/tmp/cava1.fifo"
try:
    os.mkfifo(pipe)
except FileExistsError:
    pass

# Write cava config
config_file = "/tmp/polybar_cava_config"
with open(config_file, "w") as f:
    f.write(
        "[general]\n"
        "bars = 10\n"
        "[output]\n"
        "method = raw\n"
        f"raw_target = {pipe}\n"
        "data_format = ascii\n"
        "ascii_max_range = 7\n"
    )

# Run cava in the background
os.system(f"cava -p {config_file} &")

# Read data from the named pipe and convert to progress bars
with open(pipe, "r") as f:
    while True:
        data = f.readline().strip()
        if not data:
            continue
        # Remove semicolons from data and convert to progress bars
        progress_bars = data.replace(';', '').translate(translator)
        print(progress_bars)

