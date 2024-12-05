return {
	"echasnovski/mini.icons",
	version = "*",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		local mi = require("mini.icons")
		mi.mock_nvim_web_devicons()
	end,
}
