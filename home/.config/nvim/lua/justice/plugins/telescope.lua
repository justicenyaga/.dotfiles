return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						preview_width = 0.60,
						preview_cutoff = 100,
						prompt_position = "top",
					},
				},
				sorting_strategy = "ascending",
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					follow = true,
				},
			},
		})

		telescope.load_extension("fzf")

		local custom_find_files
		custom_find_files = function(opts, no_ignore)
			opts = opts or {}
			no_ignore = vim.F.if_nil(no_ignore, false)
			opts.attach_mappings = function(_, map)
				map({ "n", "i" }, "<C-h>", function(prompt_bufnr)
					local prompt = require("telescope.actions.state").get_current_line()
					require("telescope.actions").close(prompt_bufnr)
					no_ignore = not no_ignore
					custom_find_files({ default_text = prompt }, no_ignore)
				end)
				return true
			end

			if no_ignore then
				opts.no_ignore = true
				opts.hidden = true
				opts.prompt_title = "Find Files <ALL>"
			else
				opts.prompt_title = "Find Files"
			end

			builtin.find_files(opts)
		end
	end,
}
