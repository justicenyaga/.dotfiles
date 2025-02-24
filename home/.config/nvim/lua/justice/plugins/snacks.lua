return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		words = { enabled = false },
		input = { enabled = true },
		picker = { enabled = true },
		statuscolumn = {
			enabled = true,
			folds = { open = true },
		},
		styles = {
			input = {
				relative = "cursor",
				row = 1,
				col = 0,
				width = 40,
			},
		},
	},
	keys = {
		{
			"<c-t>",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Toggle terminal",
			mode = { "n", "t" },
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit current file history",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit log",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git browse",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Open lazygit",
		},
	},
}
