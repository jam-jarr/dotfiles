#!/bin/sh

icon_file="/home/jamjar/dotfiles/.config/hypr/icons/hypr.ico"

# Define the layout cycle (scrolling -> dwindle -> master -> scrolling)
layouts="scrolling dwindle master"

workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')
current_layout=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')

# Find next layout in cycle
found=0
next_layout="scrolling"
for layout in $layouts; do
  if [ "$found" -eq 1 ]; then
    next_layout="$layout"
    break
  fi
  if [ "$layout" = "$current_layout" ]; then
    found=1
  fi
done

# Apply the new layout
hyprctl keyword workspace "$workspace_id",layout:"$next_layout" >/dev/null 2>&1

layout_text=$(echo "$next_layout" | tr '[:lower:]' '[:upper:]')

# Send notification
notify-send -t 700 -u low --transient --icon="$icon_file" "Layout: ${layout_text}"
