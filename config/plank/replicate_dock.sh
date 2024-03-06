#!/bin/bash
# Multi-monitor Plank

# remove previous docks
cd ~/.config/plank
for item in */; do
    # Check if the item is a directory and its name is not "dock1"
    if [[ -d "$item" && "$item" != "dock1/" ]]; then
        # Remove the directory
        rm -rf "$item"
        dconf reset -f /net/launchpad/plank/docks/$item
    fi
done
cd
dconf write /net/launchpad/plank/enabled-docks "['dock1']"
enabled_docks="['dock1'"

# replicate main dock in each monitor
MONITORS=$(xrandr --listmonitors | grep "Monitors" | awk '{print $NF}')
if [ $MONITORS -gt 1 ]; then
	monitor_names=$(xrandr | grep " connected" | awk '$3 !="primary" { print $1 }')
	for i in $(seq 2 $MONITORS); do
		# create the dock
		mkdir ~/.config/plank/dock$i
		cd ~/.config/plank/dock$i
		ln -s ../dock1/launchers .
		timeout 1s plank -n dock$i && wait # this creates the dock config in dconf database
		# Copy all the settings from the main dock
		for key in $(gsettings list-keys net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/); do
	    val=$(dconf read /net/launchpad/plank/docks/dock1/$key)
	    dconf write /net/launchpad/plank/docks/dock$i/$key "$val"
		done
		index=$((i - 2))
		dconf write /net/launchpad/plank/docks/dock$i/monitor "'${monitor_names[index]}'"
		enabled_docks="${enabled_docks},'dock$i'"
	done
fi
cd

# set all docks as enabled
dconf write /net/launchpad/plank/enabled-docks "${enabled_docks}]"

