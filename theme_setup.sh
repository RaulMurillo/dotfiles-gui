#!/bin/bash

# Install requirements
sudo apt install -y gnome-themes-extra gtk2-engines-murrine

mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/.fonts

# Copy resources
cp -r fonts/* ~/.fonts/

# Download theme
git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git
cd Catppuccin-GTK-Theme
cp -r themes/* ~/.themes/
cp -r extra/plank/* ~/.local/share/plank/themes
cd ..
rm -r Catppuccin-GTK-Theme

# Download icons
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
git clone https://github.com/catppuccin/papirus-folders.git
cd papirus-icon-theme
cp -r Papirus ~/.icons/
cd ../papirus-folders
cp -r src/* ~/.icons/Papirus
./papirus-folders -C cat-mocha-mauve --theme Papirus
cd ..
rm -rf papirus-icon-theme papirus-folders

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
sudo apt install -y fonts-powerline

if [ "$DESKTOP_SESSION" = "cinnamon" ]; then
	# Terminal font
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ font "'Hack 10'"
fi

