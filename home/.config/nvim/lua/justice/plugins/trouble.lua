return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {},
	cmd = "Trouble",
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "Toggle trouble list" },
		{
			"<leader>xb",
			"<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
			desc = "Toggle buffer trouble list",
		},
		{ "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Toggle symbols (Trouble)" },
		{
			"<leader>xl",
			"<cmd>Trouble lsp toggle win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{ "<leader>xq", "<cmd>Trouble qflist toggle focus=true<CR>", desc = "Toggle trouble quickfix list" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle focus=true<CR>", desc = "Toggle trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle focus=true<CR>", desc = "Toggle todos in trouble" },
	},
}
