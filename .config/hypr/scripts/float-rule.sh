# This script automatically sets a floating rule to the active window in hyprland
set -eux

class=$(hyprctl activewindow -j | jq -r '.class')

title=$(hyprctl activewindow -j | jq -r '.title')

# Append

rule="windowrule = float on, match:class $class, match:title $title"

echo "$rule" >>~/.config/hypr/hyprland-floatlist.conf

notify-send "Floating rule set for $title - $class"
