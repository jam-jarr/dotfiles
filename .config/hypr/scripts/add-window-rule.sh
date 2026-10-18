#!/bin/bash
set -e

RULES_FILE="$HOME/.config/hypr/auto-rule.lua"

active=$(hyprctl activewindow -j 2>/dev/null) || {
  notify-send --transient 'Hyprland' 'No active window found'
  exit 1
}

class=$(echo "$active" | jq -r '.class')
title=$(echo "$active" | jq -r '.title')

[ -z "$class" ] && class="(empty)"
[ -z "$title" ] && title="(empty)"

# ── Match-type menu ──
declare -A match_map=(
  ["class"]="class = \"$class\""
  ["class + title"]="class = \"$class\", title = \"$title\""
  ["title"]="title = \"$title\""
)

match_type=$(printf "%s\n" "${!match_map[@]}" | rofi -dmenu -p "Match by" -no-custom) || exit 1
match="${match_map[$match_type]}"
[ -n "$match" ] || exit 1

# ── Rule menu ──
declare -A rule_map=(
  ["no blur"]="no_blur = true"
  ["opaque"]="opacity = 1"
  ["no screen share"]="no_screen_share = true"
  ["no xray"]="xray = false"
)

rule_name=$(printf "%s\n" "${!rule_map[@]}" | rofi -dmenu -p "Rule" -no-custom) || exit 1
prop="${rule_map[$rule_name]}"
[ -n "$prop" ] || exit 1

# ── Persist to auto-rule.lua ──
cat >>"$RULES_FILE" <<EOF
hl.window_rule({ match = { $match }, $prop })
EOF

# ── Apply immediately via hyprctl keyword windowrule ──
#     hyprctl keyword windowrule takes colon-syntax:  "RULE, REGEX"
#     We map both the Lua rule and match back to the colon format.

case "$rule_name" in
  "no blur")         hypr_rule="noblur" ;;
  "opaque")          hypr_rule="opacity 1 override" ;;
  "no screen share") hypr_rule="noscreenshare" ;;
  "no xray")         hypr_rule="xray 0" ;;
esac

# Escape regex-special chars in class/title for the hyprctl regex match
escape_regex() { sed 's/[.[\*^$()+?{|]/\\&/g' <<<"$1"; }

case "$match_type" in
  "class")
    hypr_match="class:^$(escape_regex "$class")\$" ;;
  "class + title")
    hypr_match="class:^$(escape_regex "$class")\$,title:^$(escape_regex "$title")\$" ;;
  "title")
    hypr_match="title:^$(escape_regex "$title")\$" ;;
esac

hyprctl keyword windowrule "$hypr_rule, $hypr_match" 2>/dev/null || true

notify-send --transient 'Rule added' \
  "hl.window_rule({ match = { $match }, $prop })"
