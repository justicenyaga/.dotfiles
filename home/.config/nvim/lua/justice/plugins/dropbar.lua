return {
	"Bekaboo/dropbar.nvim",
	config = function()
		local sources = require("dropbar.sources")

		require("dropbar").setup({
			symbol = { on_click = false }, -- Disable symbol click
			bar = { sources = { sources.path } }, -- Display path source only
			icons = {
				kinds = { symbols = { Folder = "" } },
				ui = { bar = { separator = "  " } },
			},
		})
	end,
}
