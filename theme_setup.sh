#!/bin/bash

DIR=$PWD

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

# Install requirements
if [ "$SUDO_VAR" = "yes" ]; then
    sudo apt install -y gnome-themes-extra gtk2-engines-murrine
fi


mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/.fonts
mkdir -p ~/.local/share/plank/themes

# Copy resources
cp -r fonts/* ~/.fonts/

# Download theme
git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git
cd Catppuccin-GTK-Theme
cp -r themes/* ~/.themes/
cp -r extra/plank/* ~/.local/share/plank/themes
cd $DIR
rm -rf Catppuccin-GTK-Theme

# Download icons
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
git clone https://github.com/catppuccin/papirus-folders.git
cd $DIR/papirus-icon-theme
cp -r Papirus ~/.icons/
cd $DIR/papirus-folders
cp -r src/* ~/.icons/Papirus
./papirus-folders -C cat-mocha-mauve --theme Papirus
cd $DIR
rm -rf papirus-icon-theme
rm -rf papirus-folders

# Apply the themes and icons
if [ "$DESKTOP_SESSION" = "cinnamon" ]; then
	gsettings set org.cinnamon.theme name "Catppuccin-Mocha-B"
	gsettings set org.cinnamon.desktop.interface gtk-theme "Catppuccin-Mocha-B"
	gsettings set org.cinnamon.desktop.wm.preferences theme "Catppuccin-Mocha-B"
	gsettings set org.cinnamon.desktop.interface icon-theme "Papirus"
	# Change buttons to the left
	gsettings set org.cinnamon.desktop.wm.preferences button-layout 'close,maximize,minimize:'
fi
# Apply to Plank
dconf write /net/launchpad/plank/docks/dock1/theme "'Catppuccin-Mocha-BL'"

# Customize terminal
## Install requirements
if [ "$SUDO_VAR" = "yes" ]; then
    sudo apt install -y fonts-powerline
fi

if [ "$DESKTOP_SESSION" = "cinnamon" ]; then
	# Terminal font
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ font "'Hack 10'"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ use-system-font "false"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ use-theme-transparency "false"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ use-transparent-background "true"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ background-transparency-percent "10"
fi

