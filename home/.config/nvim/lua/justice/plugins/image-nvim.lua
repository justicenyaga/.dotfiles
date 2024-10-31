return {
	"3rd/image.nvim",
	dependencies = { "luarocks.nvim" },
	config = function()
		require("image").setup({
			integrations = {
				markdown = { only_render_image_at_cursor = true },
				neorg = { only_render_image_at_cursor = true },
				html = { enabled = false },
				css = { enabled = false },
			},
			max_height_window_percentage = 40,
			editor_only_render_when_focused = true,
			tmux_show_only_in_active_window = true,
		})
	end,
}
