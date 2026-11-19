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
    hyprctl --instance 0 eval 'hl.monitor({ output = "eDP-1", disabled = true })'
    restart_waybar "HDMI-A-1"

  elif [[ "$event" == "monitorremoved>>HDMI-A-1" ]]; then
    echo "monitor removed: $1" >> /tmp/monitor-debug.log
    hyprctl --instance 0 eval 'hl.monitor({ output = "eDP-1", mode = "1920x1200", position = "1920x0", scale = 1 })'
    restart_waybar "eDP-1"
  fi
}

INSTANCE=$(ls $XDG_RUNTIME_DIR/hypr/ | grep -v lock | tail -1)
SOCKET="$XDG_RUNTIME_DIR/hypr/$INSTANCE/.socket2.sock"
socat - "UNIX-CONNECT:$SOCKET" | while read -r line; do
  handle_event "$line"
done
