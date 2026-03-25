#!/bin/sh

# Get current workspace ID
workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')

# Set workspace to master layout
hyprctl keyword workspace "$workspace_id",layout:master >/dev/null 2>&1

# Set master window to 70% (mfact 0.7)
hyprctl dispatch layoutmsg mfact exact 0.7 >/dev/null 2>&1

# Notification
notify-send -t 2000 -u low --transient --icon="/home/jamjar/dotfiles/.config/hypr/icons/hypr.ico" "Master Layout" "Set to 70/30 split"
