#!/bin/bash

# ────────────────────────────────────────────────────────────┤ night light ├───
# Script to toggle night light (redshift/gammastep) and display status

# Configuration
TEMP_DAY=6500    # Day temperature
TEMP_NIGHT=3000  # Night temperature

# Check if redshift or gammastep is installed
if command -v redshift >/dev/null 2>&1; then
    TOOL="redshift"
elif command -v gammastep >/dev/null 2>&1; then
    TOOL="gammastep"
else
    echo '{"text":"󰌵","tooltip":"Night light tool not found. Install redshift or gammastep.","class":"error"}'
    exit 1
fi

# Function to check if night light is active
check_status() {
    if pgrep -x "$TOOL" >/dev/null; then
        return 0  # Active
    else
        return 1  # Inactive
    fi
}

# Function to toggle night light
toggle() {
    if check_status; then
        # Night light is on, turn it off
        pkill -x "$TOOL"
    else
        # Night light is off, turn it on
        $TOOL -O $TEMP_NIGHT >/dev/null 2>&1 &
    fi
}

# Handle arguments
case "$1" in
    "toggle")
        toggle
        ;;
    *)
        # Default: return status for waybar
        if check_status; then
            echo '{"text":"󰌶","tooltip":"Night Light: ON (Click to turn off)","class":"active"}'
        else
            echo '{"text":"󰌵","tooltip":"Night Light: OFF (Click to turn on)","class":"inactive"}'
        fi
        ;;
esac
