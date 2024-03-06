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

# Install Plank
if [ "$SUDO_VAR" = "yes" ]; then
    sudo apt install -y plank
fi


# Customize and config Plank
dconf write /net/launchpad/plank/docks/dock1/zoom-enabled "true"

# Create dock items
rm $HOME/.config/plank/dock1/launchers/*.dockitem

# The order the apps will be shown
DOCKAPPS="org.gnome.Calendar \
microsoft-edge \
firefox \
nemo \
org.gnome.meld \
org.gnome.Terminal \
code \
spotube \
"
DOCKITEMS="["
for item in $DOCKAPPS; do
	if [ -f "/usr/share/applications/$item.desktop" ]; then
	echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/$item.desktop" > $HOME/.config/plank/dock1/launchers/$item.dockitem
	DOCKITEMS+="'$item.dockitem', "
	fi
done
# Remove the trailing comma and add the closing bracket
DOCKITEMS="${DOCKITEMS%, }]"

# Set the dock items
dconf write /net/launchpad/plank/docks/dock1/dock-items "$DOCKITEMS"

# Set Plank as autostart app
echo '[Desktop Entry]
Type=Application
Exec=sh -c "$HOME/.config/plank/replicate_dock.sh ; plank"
Hidden=false
NoDisplay=false
Name[en_US]=Plank
Name=Plank
Comment[en_US]=Plank dock
Comment=Plank dock
X-GNOME-Autostart-Delay=2
X-GNOME-Autostart-enabled=true' > $HOME/.config/autostart/plank.desktop

cp config/plank/* ~/.config/plank/

