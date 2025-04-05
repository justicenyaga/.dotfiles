return {
	"echasnovski/mini.files",
	version = "*",
	dependencies = {
		"folke/snacks.nvim",
	},
	init = function()
		local mf = require("mini.files")

		local show_dotfiles = true

		local filter_show = function(fs_entry)
			return true
		end

		local filter_hide = function(fs_entry)
			return not vim.startswith(fs_entry.name, ".")
		end

		local toggle_dotfiles = function()
			show_dotfiles = not show_dotfiles
			local new_filter = show_dotfiles and filter_show or filter_hide
			mf.refresh({ content = { filter = new_filter } })
		end

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesWindowOpen",
			callback = function(args)
				local win_id = args.data.win_id
				vim.api.nvim_win_set_config(win_id, { border = "rounded" })
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesBufferCreate",
			callback = function(args)
				local buf_id = args.data.buf_id
				vim.keymap.set("n", "<C-h>", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
				vim.keymap.set("n", "gr", mf.refresh, { buffer = buf_id, desc = "Refresh" })
				vim.keymap.set("n", "<cr>", function()
					mf.go_in({ close_on_file = true })
				end, { buffer = buf_id, desc = "Go in entry plus" })
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})
	end,
	config = function()
		local mf = require("mini.files")
		mf.setup({
			mappings = {
				go_in = "L",
				go_in_plus = "l",
				go_out = "H",
				go_out_plus = "h",
				synchronize = "S",
			},
			windows = {
				width_focus = 40,
			},
		})

		local toggle_explorer = function()
			if not mf.close() then
				mf.open()
			end
		end

		local toggle_explorer_on_file = function()
			if not mf.close() then
				mf.open(vim.api.nvim_buf_get_name(0))
			end
		end

		vim.keymap.set("n", "<leader>ee", toggle_explorer_on_file, { desc = "Toggle file explorer on current file" })
		vim.keymap.set("n", "<leader>ef", toggle_explorer, { desc = "Toggle file explorer" })
	end,
}
