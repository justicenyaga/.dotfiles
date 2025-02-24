return {
	"nvim-telescope/telescope.nvim",
	enabled = false,
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

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", custom_find_files, { desc = "Find files in cwd" })
		keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Find recent files" })
		keymap.set("n", "<leader>f/", builtin.live_grep, { desc = "Grep in cwd" })
		keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Grep word under cursor in cwd" })
		keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, { desc = "Find workspace symbols" })
		keymap.set("n", "<leader>fS", builtin.lsp_document_symbols, { desc = "Find document symbols" })
		keymap.set("n", "<leader>fl", builtin.resume, { desc = "Resume the last find/grep session" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })

		keymap.set("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find files in neovim config dir" })

		keymap.set("n", "<leader>fo", function()
			builtin.find_files({ search_dirs = { "~/obsidian/notes", "~/obsidian/inbox" } })
		end, { desc = "Find files in obsidian vault" })

		keymap.set("n", "<leader>fb", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				previewer = false,
			}))
		end, { desc = "Grep in current buffer" })

		keymap.set("n", "<leader>fB", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Grep in open buffers" })
	end,
}
