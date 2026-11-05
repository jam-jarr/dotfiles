local M = {}

M.s_widths = { 0.333333, 0.666677, 0.985 }

M.terminal = "foot"
M.fileManager = "foot -e yazi"
M.menu = "rofi -show drun"
M.windowselector = "rofi -show window"
M.notificationMenu = "sleep 0.1 && swaync-client -t -sw"
M.screenshotter = "~/.config/hypr/scripts/dot-screenshot.sh"
M.clipboardManager = "cliphist list | rofi -dmenu -display- columns 2 -i | cliphist decode | wl-copy"
M.windowInfo = "~/.config/hypr/scripts/windowinfo.sh"
M.addWindowRule = "~/.config/hypr/scripts/add-window-rule.sh"
M.volume = "pavucontrol"
M.idle = "hypridle -g 10"

return M
