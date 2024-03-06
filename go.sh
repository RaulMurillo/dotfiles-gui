#!/bin/bash

# Install commmon software
bash install_apps.sh
# Modify desktop appearence and panel
bash desktop_setup.sh
# Install and configure Plank dock
bash plank_setup.sh
# Install and configure Conky
bash conky_setup.sh
# Modify general appearence
bash theme_setup.sh

# Need to log-out
display_banner() {
    echo "*************************************************"
    echo "*                                               *"
    echo "*           Customization completed             *"
    echo "*                                               *"
    echo "*          IT IS NECESSARY TO LOG OUT           *"
    echo "*                                               *"
    echo "*     The current repository can be deleted     *"
    echo "*                                               *"
    echo "*************************************************"
}

# Call the function to display the banner
display_banner

