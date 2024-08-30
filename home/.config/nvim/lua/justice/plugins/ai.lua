return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("codeium").setup({
			enable_chat = true,
		})
	end,

	-- "zbirenbaum/copilot.lua",
	-- cmd = "Copilot",
	-- event = "InsertEnter",
	-- dependencies = "zbirenbaum/copilot-cmp",
	-- config = function()
	-- 	require("copilot").setup({
	-- 		panel = { enabled = false },
	-- 		suggestion = { auto_trigger = false },
	-- 		filetypes = {
	-- 			yaml = true,
	-- 			markdown = true,
	-- 		},
	-- 	})
	--
	-- 	require("copilot_cmp").setup({
	-- 		formatters = {
	-- 			insert_text = require("copilot_cmp.format").remove_existing,
	-- 		},
	-- 	})
	-- end,
}
