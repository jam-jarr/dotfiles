#!/bin/bash
# Rofi-based wallpaper picker for awww daemon
# Uses image previews to select wallpapers

set -o pipefail
set -o nounset

# Configuration - change this to your wallpaper directory
WALLPAPER_DIR="${HOME}/.config/wallpapers"

# Supported image extensions
EXTENSIONS="jpg|jpeg|png|gif|webp|bmp"

# Ensure wallpaper directory exists
if [[ ! -d "${WALLPAPER_DIR}" ]]; then
  notify-send "Wallpaper Picker" "Directory ${WALLPAPER_DIR} does not exist!"
  exit 1
fi

# Find all image files
mapfile -t wallpapers < <(find "${WALLPAPER_DIR}" -maxdepth 1 -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
  -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | sort)

if [[ ${#wallpapers[@]} -eq 0 ]]; then
  notify-send "Wallpaper Picker" "No wallpapers found in ${WALLPAPER_DIR}"
  exit 1
fi

# Create menu entries with image previews for rofi
# Format: display_name\0icon\x1f/path/to/image
menu_entries=()
for wallpaper in "${wallpapers[@]}"; do
  wallpaper_name=$(basename "${wallpaper}")
  # Use the image itself as the icon for preview
  menu_entries+=("${wallpaper_name}")
done

# Show rofi menu with image previews
# Use -show-icons and format with icon paths
selected_name=$(for wallpaper in "${wallpapers[@]}"; do
  wallpaper_name=$(basename "${wallpaper}")
  printf '%s\0icon\x1f%s\n' "${wallpaper_name}" "${wallpaper}"
done |
  rofi -dmenu \
    -p "Select Wallpaper" \
    -theme-str 'window { width: 700px; } listview { lines: 5; } element-icon { size: 150px; }' \
    -theme catppuccin \
    -show-icons)

# Exit if nothing selected
[[ -z "${selected_name}" ]] && exit 0

# Find full path of selected wallpaper
selected_wallpaper=""
for wallpaper in "${wallpapers[@]}"; do
  if [[ "$(basename "${wallpaper}")" == "${selected_name}" ]]; then
    selected_wallpaper="${wallpaper}"
    break
  fi
done

# Set wallpaper using awww
if [[ -n "${selected_wallpaper}" ]]; then
  # Get current monitor
  monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

  # Set the wallpaper with nice transition
  awww img "${selected_wallpaper}" \
    --transition-type grow \
    --transition-pos center \
    --transition-step 90 \
    --transition-fps 60 \
    --transition-duration 1.0

  notify-send "Wallpaper Changed" "${selected_name}" -i "${selected_wallpaper}"
fi
