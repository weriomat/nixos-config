hl.window_rule({
	match = { class = "^(xwaylandvideobridge)$" },

	opacity = "0.0 0.0",
	no_anim = true,
	no_initial_focus = true,
	max_size = { 1, 1 },
	no_blur = true,
})

-- thunderbird confirm window to next inbox
hl.window_rule({
	match = { class = "^(thunderbird).*", title = "^(Confirm).*" },

	stay_focused = true,
	dim_around = true,
	center = true,
})

-- thunderbird filter rules window
hl.window_rule({
	match = { class = "^(thunderbird).*", title = "^(Filter Rules).*" },

	float = true,
	dim_around = true,
	center = true,
})

-- pinentry
hl.window_rule({
	match = { class = "^(Pinentry).*" },

	stay_focused = true,
	dim_around = true,
	center = true,
})

-- hyprland share picker
hl.window_rule({
	match = { title = "MainPicker" },

	stay_focused = true,
	float = true,
	dim_around = true,
	center = true,
})

-- fix xwayland apps
hl.window_rule({
	match = { xwayland = true },

	rounding = 0,
})

-- # throw sharing indicators away
-- "workspace special silent, title:^(Firefox — Sharing Indicator)$"
-- "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
