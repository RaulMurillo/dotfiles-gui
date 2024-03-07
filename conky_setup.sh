#!/bin/bash

# Check if the variable is passed
if [ -z "$1" ]; then
    echo "Installing packages in the system requires sudo permission."
    read -rp "Do you want to install packages?: (Y/n): " user_response
    if [ "$user_response" = "y" ] || [ "$user_response" = "Y" ] || [ "$user_response" = "" ]; then
        SUDO_VAR="yes"
    else
        SUDO_VAR="no"
    fi
else
    SUDO_VAR=$1
fi

# Install Conky and manager
if [ "$SUDO_VAR" = "yes" ]; then
    sudo add-apt-repository -y ppa:teejee2008/foss
    sudo apt update
    sudo apt install -y conky-all conky-manager2
fi

# Config Conky - a light-weight system monitor software for Linux
echo '[Desktop Entry]
Type=Application
Exec=sh -c "$HOME/.conky/conky-startup.sh"
Hidden=false
NoDisplay=false
Name[en_IN]=Conky
Name=Conky
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=2
Comment[en_IN]=
Comment=' > ~/.config/autostart/conky.desktop

cp -rT conky/ ~/.conky
