#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar/config"

restart_waybar() {
  echo "restart waybar: $1" >> /tmp/monitor-debug.log
  local output="$1"
  killall waybar 2>/dev/null
  sleep 0.2
  sed -i "s/\"output\": \".*\"/\"output\": \"$output\"/" "$WAYBAR_CONFIG"
  waybar &
}

handle_event() {
  echo "handle event: $1" >> /tmp/monitor-debug.log
  local event="$1"

  if [[ "$event" == "monitoradded>>HDMI-A-1" ]]; then
    echo "monitor added: $1" >> /tmp/monitor-debug.log
    hyprctl --instance 0 keyword monitor "eDP-1, disable"
    restart_waybar "HDMI-A-1"

  elif [[ "$event" == "monitorremoved>>HDMI-A-1" ]]; then
    echo "monitor removed: $1" >> /tmp/monitor-debug.log
    hyprctl --instance 0 keyword monitor "eDP-1, 1920x1200, 1920x0, 1"
    restart_waybar "eDP-1"
  fi
}

INSTANCE=$(ls $XDG_RUNTIME_DIR/hypr/ | grep -v lock | tail -1)
SOCKET="$XDG_RUNTIME_DIR/hypr/$INSTANCE/.socket2.sock"
socat - "UNIX-CONNECT:$SOCKET" | while read -r line; do
  handle_event "$line"
done
