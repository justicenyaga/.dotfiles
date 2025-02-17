return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	opts = {},
	config = function()
		require("notify").setup({
			timeout = 3500,
		})

		require("noice").setup({
			-- cmdline = {
			--   view = "cmdline",
			-- },
			views = {
				hover = {
					border = { style = "rounded" },
					size = { max_width = 80 },
				},
			},
			lsp = {
				progress = {
					format_done = "", -- disable done format
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, --add a border to hover docs and signature help
				},
				signature = {
					auto_open = {
						enabled = false,
						trigger = false,
						luasnip = false,
					},
				},
			},
			routes = {
				{
					filter = {
						event = { "msg_show", "notify" },
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
							{ find = "%d fewer lines" },
							{ find = "%d more lines" },
							{ find = "DBUI" },
							{ find = "DB:" },
							{ find = "No information available" },
						},
					},
					opts = { skip = true },
				},
			},
		})

		vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-d>"
			end
		end, { silent = true, expr = true, desc = "Scroll lsp hover doc down" })

		vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-u>"
			end
		end, { silent = true, expr = true, desc = "Scroll lsp hover doc up" })
	end,
}
