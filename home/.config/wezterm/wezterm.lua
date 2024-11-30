local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("CaskaydiaCove NFM")
config.font_size = 12

config.freetype_load_flags = "NO_HINTING"
config.cell_width = 0.9

config.default_cursor_style = "BlinkingBar"

config.enable_wayland = false

config.enable_tab_bar = false

config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 2,
	right = 2,
	top = 10,
	bottom = 10,
}

config.keys = {
	{
		key = "f",
		mods = "ALT",
		action = wezterm.action({
			Multiple = {
				wezterm.action({ SendString = "tmux-sessionizer" }),
				wezterm.action({ SendKey = { key = "Enter" } }),
			},
		}),
	},
}

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
}

return config
