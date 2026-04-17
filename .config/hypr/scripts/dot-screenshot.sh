#!/bin/sh
# Take a screenshot in a number of different ways. Any of the case statement
# options can be passed in as a value.

set -eux

MODE="${1:-region}"

case "${MODE}" in
region)
  hyprshot --freeze -m region -r --
  ;;
window)
  hyprshot --freeze -m window -r --
  ;;
monitor-focused)
  grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" -
  ;;
monitor-all)
  grim -
  ;;
*)
  echo "'${MODE}' is not a supported, aborting!" >&2
  exit 1
  ;;
esac | satty --filename - --output-filename "$HOME/Pictures/Screenshots/screenshot-%+.png"
