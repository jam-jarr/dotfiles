------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

----------------------------
---- AUTOSTART PROGRAMS ----
----------------------------

local terminal = "kitty"
local fileManager = "kitty -e yazi"
local menu = "rofi -show drun"
local windowselector = "rofi -show window"
local notificationMenu = "sleep 0.1 && swaync-client -t -sw"
local screenshotter = "~/.config/hypr/scripts/dot-screenshot.sh"
local clipboardManager = "cliphist list | rofi -dmenu -display- columns 2 -i | cliphist decode | wl-copy"
local windowInfo = "~/.config/hypr/scripts/windowinfo.sh"

local autostart = {
	"hypridle",
	"waybar",
	-- "copyq",
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",

	-- Keep the clipboard after closing application
	"wl-clip-persist --clipboard both",

	-- KDE Connect
	"/usr/lib/kdeconnectd",
	"kdeconnect-indicator",

	-- IDR
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

	-- Wallpaper daemon
	"awww-daemon",

	-- Authentication management
	"systemctl --user start hyprpolkitagent",
}

hl.on("hyprland.start", function()
	for i = 1, #autostart do
		print(autostart[i])
		-- hl.exec_cmd(autostart[i])
	end
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_MENU_PREFIX", "plasma-")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 4,

		col = {
			active_border = { colors = { "rgb(4159d0)", "rgb(c84fc0)", "rgb(ffcd70)" } },
			inactive_border = { colors = { "rgba(595959aa)" } },
		},

		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "scrolling",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		dim_special = 0.05,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		-- https://wiki.hypr.land/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 4,
			passes = 1,

			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	cursor = {
		hide_on_key_press = true,
	},
})

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("easeInOutQuintic", { type = "bezier", points = { { 0.83, 0 }, { 0.17, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easeInOutQuad", { type = "bezier", points = { { 0.45, 0 }, { 0.55, 1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
--           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
	scrolling = {
		column_width = 0.666,
		explicit_column_widths = { 0.333, 0.666, 0.95 },
		follow_min_visible = 0.3,
	},

	-- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
	dwindle = {
		preserve_split = true, -- You probably want this
	},

	-- See https://wiki.hypr.land/Configuring/Master-Layout/ for more
	master = {
		new_status = "master",
	},

	-- https://wiki.hypr.land/Configuring/Variables/#misc
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		numlock_by_default = true,

		touchpad = {
			natural_scroll = false,
			clickfinger_behavior = true,
		},
	},
})

hl.config({
	gestures = {
		workspace_swipe_forever = true,
		workspace_swipe_cancel_ratio = 0.3,
	},
})

hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "pinch",
	action = "cursorZoom",
	target = "+3",
})
-- TODO: Fix zoom gesture

hl.gesture({
	fingers = 3,
	direction = "left",
	action = "dispatcher",
	dispatcher = "movefocus",
	target = "left",
})

hl.gesture({
	fingers = 3,
	direction = "right",
	action = "dispatcher",
	dispatcher = "movefocus",
	target = "right",
})

local mainMod = "SUPER"

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Keywords/
-- Use `wev` to see the keycodes for the keys you want to bind

-- Launch applications
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal, { float = true, size = "700 550" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("kitty -e bluetui"))

-- Launch menu
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind("ALT + SHIFT + Space", hl.dsp.exec_cmd(windowselector))

-- Wallpaper picker
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper-picker.sh"))

-- cliphist picker
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboardManager))

-- Calculator
hl.bind(
	mainMod .. " + SHIFT + C",
	hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\"")
)

-- Emoji picker
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))

-- Screenshotting
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --clipboard-only --freeze -m region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(screenshotter .. " window"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(screenshotter .. " region"))
hl.bind(mainMod .. " + SHIFT + CONTROL + Print", hl.dsp.exec_cmd(screenshotter .. " monitor-focused"))

-- Color picker
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("hyprpicker -a"))

-- Notifications
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notificationMenu))

-- Window management
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
-- TODO: setprop dispatcher not documented in lua api
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("hyprctl dispatch setprop active opaque toggle"))
hl.bind(mainMod .. " + CONTROL + P", hl.dsp.window.pseudo({ action = "toggle" }))

-- Toggle waybar
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Window info
hl.bind(mainMod .. " + SHIFT + ALT + I", hl.dsp.exec_cmd(windowInfo))

-- Exit Hyprland
hl.bind(
	mainMod .. " + SHIFT + CONTROL + ALT + Q",
	hl.dsp.exec_cmd("hyprshutdown -t 'Shutting Down' --post-cmd 'shutdown now' --verbose")
)
hl.bind(mainMod .. " + SHIFT + CONTROL + Q", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting Down' --verbose"))

-- Lock
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- Hyprfocus
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprefficient.sh"))
hl.bind(mainMod .. " + ALT + SHIFT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprfocus.sh"))

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move panels with mainMod + shift + vim keys
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down", group_aware = true }))

-- Resize
-- TODO: resizeactive dispatcher not documented in lua api
hl.bind(mainMod .. " + Equal", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 10% 0%"))
-- TODO: resizeactive dispatcher not documented in lua api
hl.bind(mainMod .. " + Minus", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -10% 0%"))

-- Scrolling
hl.bind(mainMod .. " + period", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + M", hl.dsp.layout("fit visible"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("fit active"))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("colresize -conf"))
hl.bind(mainMod .. " + P", hl.dsp.layout("promote"))

-- Workspace and window management
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/cycle-layout.sh"))
hl.bind(mainMod .. " + SHIFT + CONTROL + ALT + F", hl.dsp.exec_cmd("~/.config/hypr/scripts/float-rule.sh"))
-- TODO: pin dispatcher not documented in lua api
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch pin active"))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.group.lock_active({ action = "toggle" }))
hl.bind(mainMod .. " + bracketleft", hl.dsp.group.active({ index = -1 }))
hl.bind(mainMod .. " + bracketright", hl.dsp.group.active({ index = 1 }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- Move requested workspace to a monitor with mainMod + ALT + [0-9]
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = i, on_current_monitor = true }))
end

-- Cycle workspace history
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Cut to magic workspace neovim
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/cut-to-magic-nvim.sh"))

-- Zoom factor (numpad)
hl.bind(
	mainMod .. " + KP_ADD",
	hl.dsp.exec_cmd(
		"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.2')"
	),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + KP_SUBTRACT",
	hl.dsp.exec_cmd(
		"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.8) | if . < 1 then 1 else . end')"
	),
	{ repeating = true }
)
hl.bind(mainMod .. " + code:90", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- TODO: windowrules, workspace rules, and layerrules still need translation
-- TODO: source = ~/.config/hypr/hyprland-floatlist.conf
-- TODO: source = ~/.config/hypr/hyproverrules.conf
