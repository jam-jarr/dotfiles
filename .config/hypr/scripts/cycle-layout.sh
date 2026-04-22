#!/bin/sh

# Get the current workspace ID
workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')

# Define the layout cycle (scrolling -> dwindle -> master -> scrolling)
layout_file="/tmp/hyprland-layout-${workspace_id}"
layouts="scrolling dwindle master"

# Get current layout from file or default to scrolling
if [ -f "$layout_file" ]; then
  current_layout=$(cat "$layout_file")
else
  # Check if workspace has a predefined layout in config
  current_layout=$(hyprctl workspacerules -j | jq -r --arg ws "$workspace_id" '.[] | select(.workspaceString == $ws) | .layout' 2>/dev/null)
  if [ -z "$current_layout" ] || [ "$current_layout" = "null" ]; then
    current_layout="scrolling"
  fi
fi

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

# Save the new layout
echo "$next_layout" >"$layout_file"

# Send notification
notify-send -t 2000 -u low --transient --icon="/home/jamjar/dotfiles/.config/hypr/icons/hypr.ico" "Layout changed" "Workspace $workspace_id: ${next_layout}"
