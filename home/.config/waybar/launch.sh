killall waybar

WAYBAR_CONFIG="$HOME/.config/waybar/config"
HDMI_CONNECTED=$(xrandr | grep "HDMI-A-1 connected")

if [ -n "$HDMI_CONNECTED" ]; then
  OUTPUT="HDMI-A-1"
else
  OUTPUT="eDP-1"
fi

sed -i "s/\"output\": \".*\"/\"output\": \"$OUTPUT\"/" $WAYBAR_CONFIG

waybar
