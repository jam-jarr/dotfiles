#!/bin/bash

RULES_FILE="$HOME/.config/hypr/rules.lua"

active=$(hyprctl activewindow -j) || {
    rofi -e "No active window found"
    exit 1
}

class=$(echo "$active" | jq -r '.class')
title=$(echo "$active" | jq -r '.title')

[ -z "$class" ] && class="(empty)"
[ -z "$title" ] && title="(empty)"

match_type=$(printf "class\nclass + title\ntitle" | rofi -dmenu -p "Match by" -no-custom) || exit 1

rule=$(printf "no blur\nopaque\nno screen share" | rofi -dmenu -p "Rule" -no-custom) || exit 1

case "$match_type" in
    "class")
        match="class = \"$class\""
        ;;
    "class + title")
        match="class = \"$class\", title = \"$title\""
        ;;
    "title")
        match="title = \"$title\""
        ;;
    *)
        exit 1
        ;;
esac

case "$rule" in
    "no blur")
        prop="no_blur = true"
        ;;
    "opaque")
        prop="opacity = 1"
        ;;
    "no screen share")
        prop="no_screen_share = true"
        ;;
    *)
        exit 1
        ;;
esac

cat >> "$RULES_FILE" <<EOF

-- Auto-generated
hl.window_rule({ match = { $match }, $prop })
EOF

notify-send "Rule added" "hl.window_rule({ match = { $match }, $prop })"
