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
		picker = {
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			win = {
				input = {
					keys = {
						["<C-f>"] = { "toggle_follow", mode = { "i", "n" } },
						["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<C-p>"] = { "toggle_preview", mode = { "i", "n" } },
						["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<C-f>"] = "toggle_follow",
						["<C-h>"] = "toggle_hidden",
						["<C-p>"] = "toggle_preview",
						["<C-d>"] = "preview_scroll_down",
						["<C-u>"] = "preview_scroll_up",
					},
				},
			},
		},
		statuscolumn = {
			enabled = true,
			folds = { open = true },
			right = { "git", "fold" },
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
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart find files",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true, follow = true })
			end,
			desc = "Find files in cwd",
		},
		{
			"<leader>f.",
			function()
				Snacks.picker.recent()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>f/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep in cwd",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep word under cursor",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Find workspace symbols",
		},
		{
			"<leader>fS",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Find document symbols",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep open buffers",
		},
		{
			"<leader>fl",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			"<leader>fe",
			function()
				Snacks.picker.explorer()
			end,
			desc = "Toggle explorer",
		},
		{
			"<leader>fC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorscheme",
		},
		{
			"<leader>fn",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find nvim config files",
		},
		{
			"<leader>fo",
			function()
				Snacks.picker.files({ dirs = { "~/obsidian/notes", "~/obsidian/inbox" }, hidden = true, follow = true })
			end,
			desc = "Find obsidian notes",
		},
		{
			"<leader>ft",
			"<cmd>TodoTelescope<CR>",
			desc = "Find todos",
		},
		{
			"gf",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "Show lsp references",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Go to declaration",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Go to definition",
		},
		{
			"gi",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Go to implementation",
		},
		{
			"gt",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Go to type definition",
		},
	},
}
