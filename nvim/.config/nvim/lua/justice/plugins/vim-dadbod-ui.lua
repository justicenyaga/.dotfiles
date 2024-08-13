return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_use_nvim_notify = 1
		vim.g.db_ui_winwidth = 35

		vim.keymap.set("n", "<leader>dd", function()
			vim.cmd("tabnew")
			vim.cmd("DBUI")
		end, { desc = "Toggle DBUI" })
	end,
}
