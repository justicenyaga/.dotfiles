return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = { "SmiteshP/nvim-navic" },
	config = function()
		-- triggers CursorHold event faster
		vim.opt.updatetime = 200
		require("barbecue").setup({
			attach_navic = false,
			theme = "tokyonight",
			create_autocmd = false, -- prevent barbecue from updating itself automatically
		})
		vim.api.nvim_create_autocmd({
			-- "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
			"WinResized",
			"BufWinEnter",
			"CursorHold",
			"InsertLeave",
		}, {
			group = vim.api.nvim_create_augroup("barbecue.updater", {}),
			callback = function()
				require("barbecue.ui").update()
			end,
		})
	end,
}
