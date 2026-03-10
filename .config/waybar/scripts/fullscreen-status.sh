#!/bin/bash

# Get active window info in plain format
active_window=$(hyprctl activewindow 2>/dev/null)

# Check if we got valid output
if [ -z "$active_window" ] || echo "$active_window" | grep -q "^no windows"; then
    echo ""
    exit 0
fi

# Check fullscreen status from the output
# Look for "fullscreen: 1" or "fullscreen: 2"
fullscreen=$(echo "$active_window" | grep "fullscreen:" | awk '{print $2}')

case "$fullscreen" in
    1)
        # Fullscreen mode (fills entire screen, no gaps/bar)
        echo '{"text": "⛶", "tooltip": "Fullscreen (press F11 or Super+F to exit)", "class": "fullscreen", "alt": "fullscreen"}'
        ;;
    2)
        # Maximized mode (keeps gaps and bar)
        echo '{"text": "🗖", "tooltip": "Maximized (press Super+F to exit)", "class": "maximized", "alt": "maximized"}'
        ;;
    *)
        # Not fullscreen - empty output hides the module
        echo ""
        ;;
esac
