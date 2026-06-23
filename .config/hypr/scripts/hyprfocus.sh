#!/bin/sh
set -eu
FLAG_FILE='/tmp/hyprfocus'
ICON_FILE_ON="$HOME/.config/hypr/icons/hypr.ico"
ICON_FILE_OFF="$HOME/.config/hypr/icons/hypr_desaturated.ico"

turn_on() {
  if [ -f "$FLAG_FILE" ]; then
    exit 1 # Exit if already on
  fi
  touch "$FLAG_FILE"
  hyprctl --batch "\
        keyword animations:enabled 0;"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_ON" "Hyprfocus [ON]"
}

turn_off() {
  if [ ! -f "$FLAG_FILE" ]; then
    exit 1 # Exit if already off
  fi
  rm -f "$FLAG_FILE"
  hyprctl --batch "\
        keyword animations:enabled 1;"
  notify-send -t 700 -u low --transient --icon="$ICON_FILE_OFF" "Hyprfocus [OFF]"
}

case "${1:-}" in
on)
  turn_on
  ;;
off)
  turn_off
  ;;
"")
  if [ ! -f "$FLAG_FILE" ]; then
    turn_on
  else
    turn_off
  fi
  ;;
*)
  echo "Usage: $0 [on|off]" >&2
  exit 1
  ;;
esac
