return {
	"folke/trouble.nvim",
	dependencies = { "folke/todo-comments.nvim" },
	event = "VeryLazy",
	cmd = "Trouble",
	opts = {
		auto_close = true,
	},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle trouble list" },
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics filter.severity=vim.diagnostic.severity.ERROR<cr>",
			desc = "Toggle trouble list ()",
		},
		{
			"<leader>xb",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Toggle buffer trouble list",
		},
		{
			"]x",
			function()
				local trouble = require("trouble")
				trouble.next({ focus = false, new = false })
				trouble.jump_only({ focus = false, new = false })
			end,
			desc = "Go to next item on trouble list",
		},
		{
			"[x",
			function()
				local trouble = require("trouble")
				trouble.prev({ focus = false, new = false })
				trouble.jump_only({ focus = false, new = false })
			end,
			desc = "Go to prev item on trouble list",
		},
	},
}
