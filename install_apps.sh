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

if [ "$SUDO_VAR" != "yes" ]; then
    exit 0
fi

sudo apt update
sudo apt install -y software-properties-common apt-transport-https curl wget ca-certificates
sudo apt install -y git htop vim neofetch unzip screen tmux

# Meld - Visual diff and merge tool
sudo apt install -y meld

# Caffeine - Prevent desktop idleness in full-screen mode
sudo apt install -y caffeine
## Set icon as autostart app
echo '[Desktop Entry]
Type=Application
Exec=caffeine-indicator
Hidden=false
NoDisplay=false
Name[en_US]=Caffeine
Name=Caffeine
Comment[en_US]=Caffeine indicator
Comment=Caffeine indicator
X-GNOME-Autostart-Delay=2
X-GNOME-Autostart-enabled=true' > ~/.config/autostart/caffeine.desktop

# Microsoft edge & VSCode
## Setup
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" >> /etc/apt/sources.list.d/microsoft.list'
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" >> /etc/apt/sources.list.d/microsoft.list'
## Install
sudo rm microsoft.gpg
sudo apt update
sudo apt install -y microsoft-edge-stable code

# Spotube - Spotify open-source alternative
wget https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-linux-x86_64.deb
sudo apt install -y ./Spotube-linux-x86_64.deb
rm ./Spotube-linux-x86_64.deb

# Obsidian - 
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.8/obsidian_1.5.8_amd64.deb
sudo apt install -y ./obsidian_1.5.8_amd64.deb
rm ./obsidian_1.5.8_amd64.deb

