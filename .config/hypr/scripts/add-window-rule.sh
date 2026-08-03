#!/bin/bash

RULES_FILE="$HOME/.config/hypr/auto-rule.lua"

active=$(hyprctl activewindow -j) || {
  rofi -e "No active window found"
  exit 1
}

class=$(echo "$active" | jq -r '.class')
title=$(echo "$active" | jq -r '.title')

[ -z "$class" ] && class="(empty)"
[ -z "$title" ] && title="(empty)"

declare -A match_map=(
  ["class"]="class = \"$class\""
  ["class + title"]="class = \"$class\", title = \"$title\""
  ["title"]="title = \"$title\""
)

match_type=$(printf "%s\n" "${!match_map[@]}" | rofi -dmenu -p "Match by" -no-custom) || exit 1
match="${match_map[$match_type]}"
[ -n "$match" ] || exit 1

declare -A rule_map=(
  ["no blur"]="no_blur = true"
  ["opaque"]="opacity = 1"
  ["no screen share"]="no_screen_share = true"
  ["no xray"]="xray = false"
)

rule=$(printf "%s\n" "${!rule_map[@]}" | rofi -dmenu -p "Rule" -no-custom) || exit 1
prop="${rule_map[$rule]}"
[ -n "$prop" ] || exit 1

cat >>"$RULES_FILE" <<EOF
hl.window_rule({ match = { $match }, $prop })
EOF

notify-send "Rule added" "hl.window_rule({ match = { $match }, $prop })"
