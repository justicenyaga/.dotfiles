return {
	"justicenyaga/arrow.nvim",
	enabled = false,
	config = function()
		require("arrow").setup({
			leader_key = "m",
			buffer_leader_key = "M",

			index_keys = "12345sfgwrthjklSFGWRTHJKLyuiopYUIOP",

			show_icons = true,
			hide_handbook = true,
			hide_buffer_handbook = true,
			always_show_path = true,
			separate_save_and_remove = true,
			separate_by_branch = true,
			relative_path = true,

			mappings = {
				toggle = "a",
				clear_all_items = "D",
				open_vertical = "|",
				next_item = "n",
				prev_item = "p",
			},

			window = {
				border = "rounded",
			},

			per_buffer_config = {
				lines = 5,
				sort_automatically = false,
			},
		})

		local persist = require("arrow.persist")

		vim.keymap.set("n", "<C-n>", persist.next)
		vim.keymap.set("n", "<C-p>", persist.previous)
	end,
}
