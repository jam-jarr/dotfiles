#!/bin/bash
# Cut content from focused window and paste into neovim in special:magic workspace

# Step 1: Select all and cut from currently focused window
wtype -M ctrl a
sleep 0.1
wtype -M ctrl x
sleep 0.3

# Step 2: Check if there's already a neovim kitty window in special:magic
nvim_window=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:magic" and .class == "kitty" and (.title | startswith("nvim"))) | .address' | head -n1)

if [ -n "$nvim_window" ]; then
  # Existing neovim found - focus it and create new buffer + paste
  hyprctl dispatch focuswindow address:"$nvim_window"
  sleep 0.1
  # Send :enew to create new buffer, then paste from clipboard, then press Enter
  wtype -k colon
  wtype e n e w
  wtype -k Return
  sleep 0.1
  # Paste from clipboard (using "*p for system clipboard)
  wtype -k quote
  wtype asterisk
  wtype p
  wtype -k Return
else
  # No existing neovim - open new one in special:magic workspace
  hyprctl dispatch togglespecialworkspace magic
  sleep 0.1
  # Launch kitty with nvim
  kitty nvim &
  sleep 0.5
  # Get the new window address
  nvim_window=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:magic" and .class == "kitty" and (.title | startswith("nvim"))) | .address' | head -n1)
  if [ -n "$nvim_window" ]; then
    sleep 0.3
    # Paste from clipboard
    wtype -k quote
    wtype asterisk
    wtype p
    wtype -k Return
  fi
fi
