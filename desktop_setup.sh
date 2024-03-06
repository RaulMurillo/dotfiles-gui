#!/bin/bash

# Extract the value of the NAME field from /etc/os-release
OS_NAME=$(grep "^NAME=" /etc/os-release | cut -d "=" -f 2- | tr -d '"')
if [ "$OS_NAME" != "Linux Mint" ] && [ "$XDG_CURRENT_DESKTOP" != "cinnamon" ]; then
    echo "This script onky works in Linux Mint Cinnamon systems"
    exit 1
fi


# Remove unused startup applications
sudo rm /etc/xdg/autostart/mintwelcome.desktop
sudo rm /etc/xdg/autostart/mintupdate.desktop


# Customize the panel
## Modify the panel's position
gsettings set org.cinnamon panels-enabled "['1:0:top']"
gsettings set org.cinnamon panels-height ['1:30']
# https://forums.linuxmint.com/viewtopic.php?t=285940

## Install favourite applets ===================================================
cd ~/.local/share/cinnamon/applets/
wget https://cinnamon-spices.linuxmint.com/files/applets/CinnVIIStarkMenu@NikoKrause.zip && unzip CinnVIIStarkMenu@NikoKrause.zip && rm CinnVIIStarkMenu@NikoKrause.zip
wget https://cinnamon-spices.linuxmint.com/files/applets/weather@mockturtl.zip && unzip weather@mockturtl.zip && rm weather@mockturtl.zip
wget https://cinnamon-spices.linuxmint.com/files/applets/color-picker@fmete.zip && unzip color-picker@fmete.zip && rm color-picker@fmete.zip
wget https://cinnamon-spices.linuxmint.com/files/applets/show-hide-applets@mohammad-sn.zip && unzip show-hide-applets@mohammad-sn.zip && rm show-hide-applets@mohammad-sn.zip
cd

## Set applets layout
APPLETS="[\
'panel1:left:0:CinnVIIStarkMenu@NikoKrause', \
'panel1:left:1:workspace-switcher@cinnamon.org', \
'panel1:center:0:calendar@cinnamon.org', \
'panel1:right:0:network@cinnamon.org', \
'panel1:right:1:sound@cinnamon.org', \
'panel1:right:2:color-picker@fmete', \
'panel1:right:3:show-hide-applets@mohammad-sn', \
'panel1:right:4:xapp-status@cinnamon.org', \
'panel1:right:5:notifications@cinnamon.org', \
'panel1:right:6:weather@mockturtl'\
"
if [ -d "/sys/class/power_supply" ]; then
	# This is a laptop. Include battery applet
	# 'panel1:right:XX:power@cinnamon.org:XX'
	APPLETS="$APPLETS, 'panel1:right:99:power@cinnamon.org'"
fi
APPLETS="$APPLETS]"

## Enabled applets: 'panel_name:left|center|right:position:applet_name<: optional id>'
gsettings set org.cinnamon enabled-applets "$APPLETS"
"['panel1:left:0:menu@cinnamon.org:1', 'panel1:left:1:panel-launchers@cinnamon.org:3', 'panel1:left:3:window-list@cinnamon.org:53', 'panel1:center:0:panel-launchers@cinnamon.org:54', 'panel1:right:0:placesCenter@scollins:26', 'panel1:right:1:workspace-switcher@cinnamon.org:51', 'panel1:right:2:spacer@cinnamon.org:49', 'panel1:right:3:notifications@cinnamon.org:6', 'panel1:right:4:sound@cinnamon.org:13', 'panel1:right:5:network@cinnamon.org:9', 'panel1:right:6:inhibit@cinnamon.org:24', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:8:systray@cinnamon.org:23', 'panel1:right:9:calendar@cinnamon.org:12', 'panel1:right:10:turn-off-monitor@zablotski:15']"

## Change applets settings
### calendar
sed -i '/use-custom-format/,/custom-format/ s/value": false/value": true/' ~/.config/cinnamon/spices/calendar@cinnamon.org/*.json
sed -i 's/value": "%A, %B %e/value": "%b %e/g' ~/.config/cinnamon/spices/calendar@cinnamon.org/*.json

### workspace-switcher
sed -i 's/value": "visual/value": "buttons/g' ~/.config/cinnamon/spices/workspace-switcher@cinnamon.org/*.json
### CinnVIIStarkMenu
sed -i 's/value": "stark/value": "mate/g' ~/.config/cinnamon/spices/CinnVIIStarkMenu@NikoKrause/*.json


# Install favourite extensions =================================================
cd ~/.local/share/cinnamon/extensions/

wget https://cinnamon-spices.linuxmint.com/files/extensions/transparent-panels@germanfr.zip && unzip transparent-panels@germanfr.zip && rm transparent-panels@germanfr.zip
wget https://cinnamon-spices.linuxmint.com/files/extensions/gTile@shuairan.zip && unzip gTile@shuairan.zip && rm gTile@shuairan.zip
## Enabled extensions
gsettings set org.cinnamon enabled-extensions "['transparent-panels@germanfr', 'gTile@shuairan']"


# Wallpaper
## Copy resources
IMGDIR=~/Images/
if [ "$LANGUAGE" == "es_ES" ]; then # change according to language
	IMGDIR=~/Imágenes/
fi
cp -r wallpapers $IMGDIR

gsettings set org.cinnamon.desktop.background picture-uri "file:///$IMGDIR/wallpapers/deer-forest.jpg"
