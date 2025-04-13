return {
	"echasnovski/mini.icons",
	event = "VeryLazy",
	version = "*",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		local mi = require("mini.icons")
		mi.mock_nvim_web_devicons()
	end,
}
