#!/bin/bash

CURRENT=$(hyprctl getoption input:kb_variant | grep '^str:' | awk '{print $2}')

if [ "$CURRENT" = "colemak" ]; then
    hyprctl keyword input:kb_variant ""
    notify-send "Keyboard" "Switched to QWERTY" -i input-keyboard -t 2000
else
    hyprctl keyword input:kb_variant "colemak"
    notify-send "Keyboard" "Switched to Colemark" -i input-keyboard -t 2000
fi
