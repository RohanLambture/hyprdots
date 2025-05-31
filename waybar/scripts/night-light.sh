#!/bin/bash

# Night light script for Waybar
# Uses wlsunset for Wayland or redshift for X11

# State file to track night light status
STATE_FILE="$HOME/.config/waybar/.night_light_state"

# Check if we're running on Wayland or X11
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    NIGHT_LIGHT_CMD="wlsunset"
    CHECK_CMD="pgrep wlsunset"
    KILL_CMD="pkill wlsunset"
else
    NIGHT_LIGHT_CMD="redshift"
    CHECK_CMD="pgrep redshift"
    KILL_CMD="pkill redshift"
fi

# Function to check if night light is active
is_active() {
    if $CHECK_CMD > /dev/null 2>&1; then
        return 0  # Active
    else
        return 1  # Inactive
    fi
}

# Function to toggle night light
toggle_night_light() {
    if is_active; then
        # Turn off night light
        $KILL_CMD
        echo "0" > "$STATE_FILE"
        sleep 0.5  # Give time for process to stop
    else
        # Turn on night light
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            # For wlsunset (Wayland)
            # Adjust temperature and location as needed (example coordinates for New York)
            wlsunset -t 4000 -T 6500 -l 40.7 -L -74.0 > /dev/null 2>&1 &
        else
            # For redshift (X11)
            redshift -O 4000 > /dev/null 2>&1 &
        fi
        echo "1" > "$STATE_FILE"
        sleep 0.5  # Give time for process to start
    fi
}

# Function to get status for Waybar
get_status() {
    if is_active; then
        # Night light is on
        echo '{"text": "󰌶", "class": "active", "tooltip": "Night Light: ON"}'
    else
        # Night light is off
        echo '{"text": "󰌵", "class": "inactive", "tooltip": "Night Light: OFF"}'
    fi
}

# Handle command line arguments
case "$1" in
    toggle)
        toggle_night_light
        ;;
    *)
        get_status
        ;;
esac
