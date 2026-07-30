hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

local terminal = "kitty"
local fileManager = "foot -e yazi"
local menu = "rofi -show drun"
local windowselector = "rofi -show window"
local notificationMenu = "sleep 0.1 && swaync-client -t -sw"
local screenshotter = "~/.config/hypr/scripts/dot-screenshot.sh"
local clipboardManager = "cliphist list | rofi -dmenu -display- columns 2 -i | cliphist decode | wl-copy"
local windowInfo = "~/.config/hypr/scripts/windowinfo.sh"
local addWindowRule = "~/.config/hypr/scripts/add-window-rule.sh"
local volume = "pavucontrol"

ICON_FILE_ON = os.getenv("HOME") .. "/.config/hypr/icons/hypr.ico"
ICON_FILE_OFF = os.getenv("HOME") .. "/.config/hypr/icons/hypr_desaturated.ico"

local autostart = {
	"hypridle",
	"waybar",
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",

	-- Keep the clipboard after closing application
	"wl-clip-persist --clipboard both",

	-- KDE Connect
	"/usr/lib/kdeconnectd",
	"kdeconnect-indicator",

	-- IDR lmao
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

	-- Wallpaper daemon
	"awww-daemon",

	-- Authentication management
	"systemctl --user start hyprpolkitagent",
	"systemctl --user start hyprland-session.target",

	-- Allow playerctl to act on the most recent media player
	"playerctld daemon",
}

hl.on("hyprland.start", function()
	for i = 1, #autostart do
		hl.exec_cmd(autostart[i])
	end
end)

local shutdown = {
	"pkill awww",
	"systemctl --user stop hyprland-session.target && sleep 0.1",
}

hl.on("hyprland.shutdown", function()
	for i = 1, #shutdown do
		hl.exec_cmd(shutdown[i])
	end
end)

local envVars = {
	XCURSOR_SIZE = "24",
	HYPRCURSOR_SIZE = "24",
	SAL_USE_VCLPLUGIN = "qt6", -- force libreoffice to use qt6
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
	QT_QPA_PLATFORM = "wayland;xcb",
	QT_QPA_PLATFORMTHEME = "qt6ct", -- qt theme
	XDG_MENU_PREFIX = "plasma-",
	XDG_CONFIG_HOME = os.getenv("HOME") .. "/.config",
}

for k, v in pairs(envVars) do
	hl.env(k, v)
end

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 4,

		col = {
			active_border = { colors = { "rgb(4159d0)", "rgb(c84fc0)", "rgb(ffcd70)" }, angle = 45 },
			inactive_border = { colors = { "rgba(595959aa)" } },
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		dim_special = 0.05,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 1,

			vibrancy = 0.1696,
		},
	},

	cursor = {
		hide_on_key_press = true,
	},

	animations = {
		enabled = true,
	},

	scrolling = {
		wrap_swapcol = false,
		column_width = 0.66666,
		explicit_column_widths = "0.33333, 0.66666, 0.985",
		-- follow_min_visible = 0.3,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,

		sensitivity = 0,

		numlock_by_default = true,

		touchpad = {
			natural_scroll = false,
			clickfinger_behavior = true,
		},
	},
})

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
--           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
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

-- BINDS

local mainMod = "SUPER"

local function mbind(key, action)
	hl.bind(mainMod .. " + " .. key, action)
end

local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		else
			hl.dispatch(bind_table["other"])
		end
	end
end

-- Gestures
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })

hl.gesture({ fingers = 3, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

-- Close graphical session
mbind("CONTROL + SHIFT + Q", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting Down' --verbose"))

-- Pickers
mbind("Return", hl.dsp.exec_cmd(terminal))
mbind("SHIFT + Return", hl.dsp.exec_cmd(terminal, { float = true, size = { 700, 550 } }))

-- Programs
mbind("E", hl.dsp.exec_cmd(fileManager))
mbind("B", hl.dsp.exec_cmd("foot -e bluetui"))
mbind("SHIFT + B", hl.dsp.exec_cmd("rfkill toggle bluetooth"))
mbind("N", hl.dsp.exec_cmd(notificationMenu))
mbind("SHIFT + N", hl.dsp.exec_cmd("foot -e impala"))
mbind("SHIFT + A", hl.dsp.exec_cmd(volume))

-- Rofi scripts
mbind("Space", hl.dsp.exec_cmd(menu))
mbind("SHIFT + Space", hl.dsp.exec_cmd(windowselector))
mbind("SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper-picker.sh"))
mbind("V", hl.dsp.exec_cmd(clipboardManager))
mbind(
	"SHIFT + C",
	hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\"")
)
mbind("SHIFT + E", hl.dsp.exec_cmd("rofimoji --skin-tone neutral --max-recent 0"))
mbind("CONTROL + E", hl.dsp.exec_cmd("rofimoji -f general_punctuation.csv"))
-- Consider creating a rofi script to choose the file; files are located in "/usr/lib/python3.14/site-packages/picker/data"
mbind("ALT + E", hl.dsp.exec_cmd("rofimoji -f html_characters.csv"))

-- Window management
mbind("SHIFT + D", hl.dsp.window.close())
mbind("F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
mbind("SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
mbind("SHIFT + V", hl.dsp.window.float())
mbind("T", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))

-- Scrolling
mbind(
	"P",
	layout_bind({
		scrolling = hl.dsp.layout("promote"),
		other = hl.dsp.window.pseudo(),
	})
)
mbind("M", hl.dsp.layout("fit visible"))
mbind("SHIFT + M", hl.dsp.layout("fit all"))
mbind("CONTROL + M", hl.dsp.layout("fit expand"))
mbind("SHIFT + period", hl.dsp.layout("colresize +conf"))
mbind("SHIFT + comma", hl.dsp.layout("colresize -conf"))
mbind("period", hl.dsp.layout("swapcol r"))
mbind("comma", hl.dsp.layout("swapcol l"))

mbind("SHIFT + H", hl.dsp.window.move({ direction = "l", window = "activewindow" }))
mbind("SHIFT + L", hl.dsp.window.move({ direction = "r", window = "activewindow" }))
mbind("SHIFT + K", hl.dsp.window.move({ direction = "u", window = "activewindow" }))
mbind("SHIFT + J", hl.dsp.window.move({ direction = "d", window = "activewindow" }))

mbind(
	"H",
	layout_bind({
		scrolling = hl.dsp.layout("focus l"),
		other = hl.dsp.focus({ direction = "l" }),
	})
)
mbind(
	"L",
	layout_bind({
		scrolling = hl.dsp.layout("focus r"),
		other = hl.dsp.focus({ direction = "l" }),
	})
)
mbind("K", hl.dsp.focus({ direction = "u" }))
mbind("J", hl.dsp.focus({ direction = "d" }))

-- Workspace management
mbind(0, hl.dsp.focus({ workspace = 10 }))
mbind("SHIFT + " .. 0, hl.dsp.window.move({ workspace = 10, window = "activewindow", follow = true }))
for i = 1, 9 do
	mbind(i, hl.dsp.focus({ workspace = i }))
	mbind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i, window = "activewindow", follow = true }))
end
mbind("Tab", hl.dsp.focus({ workspace = "previous" }))

-- Move workspace to monitor
mbind("CONTROL + H", hl.dsp.workspace.move({ workspace = "m", monitor = "l" }))
mbind("CONTROL + L", hl.dsp.workspace.move({ workspace = "m", monitor = "r" }))
mbind("CONTROL + K", hl.dsp.workspace.move({ workspace = "m", monitor = "u" }))
mbind("CONTROL + J", hl.dsp.workspace.move({ workspace = "m", monitor = "d" }))

-- Scratchpad
mbind("S", hl.dsp.workspace.toggle_special("magic"))
mbind("SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.workspace_rule({ workspace = "special:magic", layout = "dwindle" })

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
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Utilities
mbind("SHIFT + I", hl.dsp.exec_cmd(windowInfo))
mbind("SHIFT + O", hl.dsp.exec_cmd("hyprshot --freeze -m region -r -- | tesseract stdin stdout | wl-copy"))
hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		'hyprshot -s --clipboard-only --freeze -m region && notify-send "Copied to clipboard" --transient -t 900'
	)
)
mbind("Print", hl.dsp.exec_cmd(screenshotter .. " window"))
mbind("SHIFT + Print", hl.dsp.exec_cmd(screenshotter .. " region"))
mbind("CONTROL + Print", hl.dsp.exec_cmd(screenshotter .. " monitor-all"))
mbind("ALT + L", hl.dsp.exec_cmd("hyprlock"))
mbind("SHIFT + R", hl.dsp.exec_cmd(addWindowRule))

-- COMPLEX BINDS
local transparency = hl.window_rule({
	name = "transparency-general",
	match = {
		class = ".*",
	},
	opacity = "0.93 0.93 1",
	xray = true,
})

mbind("SHIFT + T", function()
	transparency:set_enabled(not transparency:is_enabled())
end)

-- Cycle through layouts
mbind("R", function()
	local layouts = { "scrolling", "dwindle", "master" }
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

	local next_layout = "dwindle"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)

mbind("ALT + A", function()
	local isAnimate = hl.get_config("animations:enabled")
	hl.config({
		animations = {
			enabled = not isAnimate,
		},
	})
	if not isAnimate then
		hl.exec_cmd('notify-send "Hyprland" "Animations Enabled" --transient --icon=' .. ICON_FILE_ON)
	else
		hl.exec_cmd('notify-send "Hypland" "Animations Disabled" --transient --icon=' .. ICON_FILE_OFF)
	end
end)

require("rules")
