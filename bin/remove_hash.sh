#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.ini output.ini"
    exit 1
fi

# Assign input and output file names
input_file="$1"
output_file="$2"

# Check if the input file exists
if [ ! -e "$input_file" ]; then
    echo "Error: Input file not found"
    exit 1
fi

# Use sed to remove all '#' characters from the input file and save to output file
sed 's/#//g' "$input_file" > "$output_file"

echo "Process completed. '#' characters removed from $input_file and saved to $output_file"

