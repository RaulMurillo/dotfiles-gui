#!/bin/bash
# Multi-monitor Plank

# Remove previous docks
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

# Replicate main dock in each monitor
MONITORS=$(xrandr --listmonitors | grep "Monitors" | awk '{print $NF}')
if [ $MONITORS -gt 1 ]; then
	# Set dock in primary monitor as dock1
	# Needed if the primary monitor is not the default screen in multimonitor setups
	primary_monitor_name=$(xrandr | grep " connected" | awk '$3 =="primary" { print $1 }')
	dconf write /net/launchpad/plank/docks/dock1/monitor "'${primary_monitor_name}'"

	# Set the rest of the docks
	monitor_names=$(xrandr | grep " connected" | awk '$3 !="primary" { print $1 }')
	for i in $(seq 2 $MONITORS); do
		# Copy the main dock - new items must be pinned in the main dock and restart session
		cp -r ~/.config/plank/dock1 ~/.config/plank/dock$i
		## Create the docks - this does not allow to pin items in the docks
		#ln -s ~/.config/plank/dock1 ~/.config/plank/dock$i
		timeout 0.5s plank -n dock$i && wait # this creates the dock config in dconf database
		# Copy all the settings from the main dock
		for key in $(gsettings list-keys net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/); do
			val=$(dconf read /net/launchpad/plank/docks/dock1/$key)
			dconf write /net/launchpad/plank/docks/dock$i/$key "$val"
		done
		# Set the monitor
		index=$((i - 2))
		dconf write /net/launchpad/plank/docks/dock$i/monitor "'${monitor_names[index]}'"
		enabled_docks="${enabled_docks},'dock$i'"
	done
fi
cd

# Enable all docks
dconf write /net/launchpad/plank/enabled-docks "${enabled_docks}]"

