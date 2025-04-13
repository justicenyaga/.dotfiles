vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("persistence", { clear = true }),
	callback = function()
		require("persistence").load()
	end,
	nested = true,
})

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	config = function()
		require("persistence").setup({
			need = 0,
		})

		vim.keymap.set("n", "<leader>wr", function()
			require("persistence").load()
		end, { desc = "load the session for the current dir" })
		vim.keymap.set("n", "<leader>ws", function()
			require("persistence").select()
		end, { desc = "select a session to load" })
		vim.keymap.set("n", "<leader>wl", function()
			require("persistence").load({ last = true })
		end, { desc = "load last session" })
	end,
}
