#!/bin/bash

# Install Conky and manager
sudo add-apt-repository ppa:teejee2008/foss
sudo apt update
sudo apt install -y conky-all conky-manager2

# Config Conky - a light-weight system monitor software for Linux
echo '[Desktop Entry]
Type=Application
Exec=sh "~/.conky/conky-startup.sh"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_IN]=Conky
Name=Conky
Comment[en_IN]=
Comment=' > ~/.config/autostart/conky.desktop

cp -r conky ~/.conky
