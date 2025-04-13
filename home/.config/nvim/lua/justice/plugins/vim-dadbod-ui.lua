return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
	},
	event = "VeryLazy",
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		local util = require("justice.functions.util")

		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_winwidth = 32
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_table_helpers = {
			mysql = {
				List = 'select * from "{table}"',
			},
			postgres = {
				List = 'select * from "{table}"',
			},
			mariadb = {
				List = "select * from {table}",
			},
		}

		local open_in_current_tab = function()
			local open = false
			for _, buff in ipairs(vim.fn.tabpagebuflist()) do
				if util.basename(vim.api.nvim_buf_get_name(buff)) == "dbui" then
					open = true
				end
			end
			return open
		end

		vim.keymap.set("n", "<leader>dd", function()
			if open_in_current_tab() then
				vim.cmd.tabclose()
				vim.cmd.tabprev()
			else
				util.open_in_tab("dbui", false, function()
					vim.cmd("tabnew")
					vim.cmd("DBUI")
				end)
			end
		end, { desc = "Toggle DBUI" })
	end,
}
