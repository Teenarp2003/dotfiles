#!/bin/bash

# Set the name of the text file containing the list of packages
package_list="package_list.txt"

# Read each line in the text file
while read package; do
  # Install the package using pacman
sudo pacman -S --noconfirm $package
done < $package_list
# Set the name of the text file containing the list of packages
package_list="package_list_aur.txt"

# Read each line in the text file
while read package; do
  # Install the package using yay
yay -S --noconfirm $package
done < $package_list

