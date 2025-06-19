#!/bin/bash

# Script to toggle touchpad state
# Usage: toggle-touchpad.sh [enable|disable|toggle]

TOUCHPAD_DEVICE="dell09be:00-0488:120a-touchpad"

disable_touchpad() {
    echo "Disabling touchpad: $TOUCHPAD_DEVICE"
    
    if hyprctl keyword device[$TOUCHPAD_DEVICE]:enabled false 2>/dev/null; then
        echo "Touchpad disabled"
        save_touchpad_status "disabled"
        # Send notification
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Touchpad" "Touchpad disabled" --icon=input-touchpad --urgency=low
        fi
        return 0
    fi
    
    echo "Failed to disable touchpad"
    return 1
}

enable_touchpad() {
    echo "Enabling touchpad: $TOUCHPAD_DEVICE"
    
    if hyprctl keyword device[$TOUCHPAD_DEVICE]:enabled true 2>/dev/null; then
        echo "Touchpad enabled"
        save_touchpad_status "enabled"
        # Send notification
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Touchpad" "Touchpad enabled" --icon=input-touchpad --urgency=low
        fi
        return 0
    fi
    
    echo "Failed to enable touchpad"
    return 1
}

STATE_FILE="/tmp/touchpad_state"

get_touchpad_status() {
    # Read status from state file, default to enabled if file doesn't exist
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "enabled"
    fi
}

save_touchpad_status() {
    echo "$1" > "$STATE_FILE"
}

toggle_touchpad() {
    local current_status=$(get_touchpad_status)
    
    echo "Current touchpad status: $current_status"
    
    if [ "$current_status" = "disabled" ]; then
        enable_touchpad
    else
        disable_touchpad
    fi
}

# Main script logic
ACTION="$1"

if [ -z "$ACTION" ]; then
    ACTION="toggle"
fi

case "$ACTION" in
    "disable")
        disable_touchpad
        ;;
    "enable")
        enable_touchpad
        ;;
    "toggle")
        toggle_touchpad
        ;;
    *)
        echo "Usage: $0 [enable|disable|toggle]"
        echo "  enable  - Enable touchpad"
        echo "  disable - Disable touchpad"
        echo "  toggle  - Toggle current state (default)"
        echo ""
        echo "Current touchpad status: $(get_touchpad_status)"
        exit 1
        ;;
esac
