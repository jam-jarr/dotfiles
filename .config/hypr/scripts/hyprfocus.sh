#!/bin/sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
  hyprctl --batch "\
        keyword animations:enabled 0;"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE" "Hyprfocus [ON]"
  exit
else
  notify-send -t 700 -u low --transient --icon="$ICON_FILE" "Hyprfocus [OFF]"
  hyprctl reload
  exit 0
fi
exit 1
