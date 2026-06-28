#!/bin/bash
CONFIG_DIR="$HOME/.config/quickshell/sticky-notes"

if ! qs msg -p "$CONFIG_DIR" note toggle 2>/dev/null; then
    quickshell -p "$CONFIG_DIR" &
    while true; do
        result=$(qs msg -p "$CONFIG_DIR" note toggle 2>&1)
        if ! echo "$result" | grep -q "No running instances"; then
            break
        fi
        sleep 0.2
    done
fi
