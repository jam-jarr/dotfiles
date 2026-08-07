hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({

	name = "fullscreen-border",
	match = {
		fullscreen = true,
	},
	border_color = { colors = { "rgb(dac574)", "rgb(d9b656)", "rgb(671610)" }, angle = 45 },
})

hl.window_rule({

	name = "pin-border",
	match = {
		pin = true,
	},
	border_color = { colors = { "rgb(004069)", "rgb(05dcac)", "rgb(19e0ff)" }, angle = 45 },
})

hl.window_rule({
	name = "showmethekey",
	match = {
		class = "one.alynx.showmethekey",
		title = "Floating Window - Show Me The Key",
	},
	float = true,
	size = { 940, 80 },
	move = { 470, 970 },
	border_size = 0,
	xray = false,
	pin = true,
	no_blur = true,
	no_focus = true,
})

hl.window_rule({
	name = "zen-library",
	match = {
		class = "zen",
		title = "Library",
	},
	min_size = { 1000, 600 },
	xray = false,
	float = true,
})

hl.window_rule({
	name = "zoom-annotate",
	match = {
		class = "zoom",
		title = "annotate_toolbar",
	},
	float = true,
})

hl.window_rule({
	name = "keepassxc-generate",
	match = {
		class = "org.keepassxc.KeePassXC",
		title = "Generate Password",
	},
	float = true,
})

hl.window_rule({
	name = "special-noxray",
	match = {
		workspace = "special:magic",
	},
	xray = false,
	no_blur = true,
	opacity = 0.80,
	border_size = 2,
})

hl.layer_rule({
	name = "rofi",
	match = {
		namespace = "rofi",
	},
	blur = true,
	ignore_alpha = 0.2,
})

hl.layer_rule({
	name = "swaync",
	match = {
		namespace = "swaync-control-center",
	},
	blur = true,
	ignore_alpha = 0.5,
})

hl.window_rule({
	name = "keepassxc-block-capture",
	match = {
		class = "org.keepassxc.KeePassXC",
	},
	no_screen_share = true,
})

hl.window_rule({
	name = "kitty",
	match = {
		class = "kitty",
	},
	scrolling_width = 0.33333,
})

hl.window_rule({
	name = "foot",
	match = {
		class = "foot",
	},
	scrolling_width = 0.33333,
})

hl.window_rule({
	name = "youtube-opaque",
	match = { title = ".*YouTube.*" },
	opacity = 1,
})

require("auto-rule")
