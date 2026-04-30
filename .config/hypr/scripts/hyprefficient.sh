#!/bin/sh
set -eux
FLAG_FILE='/tmp/hyprefficient'
RULE_FILE="$HOME/.config/hypr/hyproverrules.conf"
ICON_FILE_ON="$HOME/.config/hypr/icons/hypr.ico"
ICON_FILE_OFF="$HOME/.config/hypr/icons/hypr_desaturated.ico"
if [ ! -f "$FLAG_FILE" ]; then
  touch "$FLAG_FILE"
  echo "windowrule = match:class .*, opacity 1" >>"$RULE_FILE"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_ON" "Hyprefficient [ON]"
else
  # Sleep is currently enabled, so disable it
  rm -f "$FLAG_FILE"
  sed -i '/windowrule = match:class .*, opacity 1/d' "$RULE_FILE"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_OFF" "Hyprefficient [OFF]"
fi
