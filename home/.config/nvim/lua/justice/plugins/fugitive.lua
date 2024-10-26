local util = require("justice.functions.util")

local api = vim.api

vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ "xdg-open", opts.fargs[1] })
end, { nargs = 1 })

local function jump_next()
	api.nvim_feedkeys(":silent! /^[?,M,A,D,U] ", "n", false)
	util.press_enter()
	api.nvim_feedkeys(":noh", "n", false)
	util.press_enter()
end

local function jump_prev()
	api.nvim_feedkeys(":silent! ?^[?,M,A,D,U] ", "n", false)
	util.press_enter()
	api.nvim_feedkeys(":noh", "n", false)
	util.press_enter()
end

local toggle_status = function()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		api.nvim_command("bd")
	else
		util.open_in_tab("fugitive", true, function()
			api.nvim_command("silent! :Git")
			api.nvim_feedkeys(api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
			jump_next()
		end)
	end
end

return {
	"tpope/vim-fugitive",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"tpope/vim-rhubarb",
	},
	config = function()
		local function map(mode, l, r, desc)
			local opts = { noremap = true, desc = desc }
			vim.keymap.set(mode, l, r, opts)
		end

		local function notify_cmd(km, cmd, title, msg)
			map("n", km, function()
				vim.notify(msg, "info", { title = title, timeout = 500 })

				vim.defer_fn(function()
					vim.cmd(cmd)
				end, 500)
			end, cmd)
		end

		map("n", "<leader>gs", toggle_status, "Toggle git status")

		map("n", "<leader>gi", ":Git init<CR>", "Git init")

		notify_cmd("<leader>gp", "Git push", "Git Push", "Pushing...")
		notify_cmd("<leader>gP", "Git push --force", "Git Push", "Force Pushing...")
		notify_cmd("<leader>gl", "Git pull", "Git Pull", "Pulling...")

		map("n", "<leader>ga", ":Git add %:p<CR>", "Stage current file")
		map("n", "<leader>gu", ":Git restore --staged %:p<CR>", "Unstage current file")
		map("n", "<leader>gw", ":Gwrite<CR>", "Save and stage current buffer")
		map("n", "<leader>gr", ":Git restore %:p<CR>", "Reset current buffer")

		map("n", "<leader>gb", ":Git checkout -b<Space>", "Create new branch")

		map("n", "<leader>gcc", ':Git commit -m ""<Left>', "Create a commit")
		map("n", "<leader>gca", ":Git commit --amend<CR>", "Ammed the last commit")

		map("n", "<leader>go", ":Git checkout<Space>", "Git checkout")
	end,
	jump_next = jump_next,
	jump_prev = jump_prev,
}
