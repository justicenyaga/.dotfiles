return {
	"stevearc/oil.nvim",
	config = function()
		local oil = require("oil")

		oil.setup({
			default_file_explorer = true,
			delete_to_trash = true,
			watch_for_changes = true,
			skip_confirm_for_simple_edits = true,
			lsp_file_methods = {
				autosave_changes = true,
			},
			float = {
				preview_split = "right",
				override = function(conf)
					local opts = {
						width = 35,
						col = 0,
						row = 0,
					}
					return vim.tbl_deep_extend("force", conf, opts)
				end,
			},
			keymaps = {
				["q"] = "actions.close",
				["h"] = "actions.parent",
				["l"] = "actions.select",
				["H"] = "actions.open_cwd",
				["S"] = oil.save,
				["<C-d>"] = "actions.preview_scroll_down",
				["<C-u>"] = "actions.preview_scroll_up",
				["<C-r>"] = "actions.refresh",
			},
		})

		vim.keymap.set("n", "<leader>ee", function()
			oil.toggle_float(".")
		end, { desc = "Toggle file explorer" })
		vim.keymap.set("n", "<leader>ef", oil.toggle_float, { desc = "Toggle file explorer on current file" })
	end,
}
