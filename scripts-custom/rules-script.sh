echo "copying udev rules"
sudo cp 51-stdfu-permissions.rules /etc/udev/rules.d/
sudo cp backlight.rules /etc/udev/rules.d/
sudo cp 99-arduino.rules /etc/udev/rules.d/
