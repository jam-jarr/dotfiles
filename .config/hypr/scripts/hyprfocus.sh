#!/bin/sh
set -eux
ICON_FILE_ON="$HOME/.config/hypr/icons/hypr.ico"
ICON_FILE_OFF="$HOME/.config/hypr/icons/hypr_desaturated.ico"
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
  hyprctl --batch "\
        keyword animations:enabled 0;"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_ON" "Hyprfocus [ON]"
  exit
else
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_OFF" "Hyprfocus [OFF]"
  hyprctl reload
  exit 0
fi
exit 1
