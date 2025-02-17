return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		-- Set the fill character for diff lines
		vim.opt.fillchars:append({ diff = "╱" })

		local actions = require("diffview.actions")
		local diffview = require("diffview")
		local cb = require("diffview.config").diffview_callback
		local notify = require("notify")
		local util = require("justice.functions.util") -- Import util functions

		-- For conciseness
		local api, cmd, fn, keymap = vim.api, vim.cmd, vim.fn, vim.keymap

		keymap.set("n", "<leader>gH", function()
			local isDiff = fn.getwinvar(nil, "&diff")
			local bufName = api.nvim_buf_get_name(0)
			diffview.FOCUSED_HISTORY_FILE = bufName
			if isDiff ~= 0 or util.string_starts(bufName, "diff") then
				-- Close diffview if it's already open
				diffview.FOCUSED_HISTORY_FILE = nil
				cmd.tabclose()
				cmd.tabprev()
			else
				util.open_in_tab("diff", true, function()
					api.nvim_feedkeys(":DiffviewFileHistory " .. fn.expand("%"), "n", false)
					util.press_enter()
				end)
			end
		end, { desc = "Toggle current file history" })

		-- Toggle file history of the repo
		keymap.set("n", "<leader>gh", function()
			local isDiff = fn.getwinvar(nil, "&diff")
			local bufName = api.nvim_buf_get_name(0)
			if isDiff ~= 0 or util.string_starts(bufName, "diff") then
				-- Close diffview if it's already open
				cmd.tabclose()
				cmd.tabprev()
			else
				util.open_in_tab("diff", true, function()
					cmd.DiffviewFileHistory()
					util.press_enter()
				end)
			end
		end, { desc = "Toggle repository history" })

		-- Toggle viewing all current changes
		-- keymap.set("n", "<leader>gda", function()
		-- local isDiff = fn.getwinvar(nil, "&diff")
		-- local bufName = api.nvim_buf_get_name(0)
		-- if isDiff ~= 0 or util.string_starts(bufName, "diff") then
		--   -- Close diffview if it's already open
		--   cmd.bd()
		--   cmd.tabprev()
		-- else
		--   -- Open diffview with all current changes
		--   cmd.DiffviewOpen()
		--   util.press_enter()
		-- end
		-- end, {desc = "Toggle viewing all current changes"})

		keymap.set("n", "<leader>ge", function()
			local isDiff = fn.getwinvar(nil, "&diff")
			local bufName = api.nvim_buf_get_name(0)

			-- Get the current branch name
			local currentBranch = util.get_branch_name()

			-- If main is currently checked out, return with a warning
			if currentBranch == "main" then
				notify("HEAD is on main", "info")
				return
			else
				-- Check if there is a branch called "main"
				-- If not, return with an error
				if not util.branch_exists("main") then
					notify("No main branch, cannot review!", "error")
					return
				end
			end
			if isDiff ~= 0 or util.string_starts(bufName, "diff") then
				-- Close diffview if it's already open
				cmd.tabclose()
				cmd.tabprev()
			else
				util.open_in_tab("diff", true, function()
					cmd.DiffviewOpen("main")
					util.press_enter()
				end)
			end
		end, { desc = "Review HEAD against main branch" }) --breaks if no main branch

		keymap.set("n", "<leader>gd", function()
			local isDiff = fn.getwinvar(nil, "&diff")
			local bufName = api.nvim_buf_get_name(0)
			if isDiff ~= 0 or util.string_starts(bufName, "diff") then
				-- Close diffview if it's already open
				cmd.tabclose()
				cmd.tabprev()
			else
				util.open_in_tab("diff", true, function()
					-- Open diffview
					cmd.DiffviewOpen()
				end)
			end
		end, { desc = "Toggle git diffview" })

		diffview.setup({
			view = {
				default = {
					winbar_info = false,
				},
				file_history = {
					winbar_info = false,
				},
			},
			diff_binaries = false,
			use_icons = true, -- Requires nvim-web-devicons
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			signs = { fold_closed = "", fold_open = "" },
			file_panel = {
				listing_style = "list", -- One of 'list' or 'tree'
				tree_options = {
					-- Only applies when listing_style is 'tree'
					flatten_dirs = true, -- Flatten dirs that only contain one single dir
					folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
				},
				win_config = {
					width = 25,
				},
			},
			enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
			default_args = {
				-- Default args prepended to the arg-list for the listed commands
				DiffviewOpen = {},
				DiffviewFileHistory = {
					-- Follow only the first parent upon seeing a merge commit.
					first_parent = true,
					-- Include all refs.
					all = true,
					-- List only merge commits.
					merges = false,
					-- List commits in reverse order.
					reverse = false,
				},
			},
			hooks = {}, -- See ':h diffview-config-hooks'
			key_bindings = {
				disable_defaults = true, -- Disable the default key bindings
				-- The `view` bindings are active in the diff buffers, only when the current
				-- tabpage is a Diffview.
				view = {
					["<C-j>"] = cb("select_next_entry"), -- Open the diff for the next file
					["<C-k>"] = cb("select_prev_entry"), -- Open the diff for the previous file
					["<CR>"] = cb("goto_file_edit"), -- Open the file in a new split in previous tabpage
					["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
					["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
					["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
					["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
					["<leader>co"] = actions.conflict_choose("ours"), -- Choose the OURS version of a conflict
					["<leader>ct"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
					["<leader>cb"] = actions.conflict_choose("base"), -- Choose BASE versions of a conflict
					["<leader>ca"] = actions.conflict_choose("all"), -- Choose all versions of a conflict
					["dx"] = actions.conflict_choose("none"), -- Delete the conflict region
					["<leader>cO"] = actions.conflict_choose_all("ours"), -- Choose the OURS version of a conflict for the whole file
					["<leader>cT"] = actions.conflict_choose_all("theirs"), -- Choose the THEIRS version of a conflict for the whole file
					["<leader>cB"] = actions.conflict_choose_all("base"), -- Choose BASE versions of a conflict for the whole file
					["<leader>cA"] = actions.conflict_choose_all("all"), -- Choose all versions of a conflict for the whole file
					["dX"] = actions.conflict_choose_all("none"), -- Delete the conflict region for the whole file
				},
				file_panel = {
					["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
					["<down>"] = cb("next_entry"),
					["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
					["<up>"] = cb("prev_entry"),
					["o"] = cb("select_entry"),
					["<2-LeftMouse>"] = cb("select_entry"),
					["s"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
					["S"] = cb("stage_all"), -- Stage all entries.
					["U"] = cb("unstage_all"), -- Unstage all entries.
					["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
					["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
					["<S-Up>"] = actions.scroll_view(-20),
					["<S-Down>"] = actions.scroll_view(20),
					["<C-j>"] = cb("select_next_entry"),
					["<C-k>"] = cb("select_prev_entry"),
					["gf"] = cb("goto_file"),
					["<cr>"] = cb("goto_file_tab"),
					["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
					["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
					-- ["<leader>e"] = cb("focus_files"),
					["<leader>e"] = cb("toggle_files"),
					["<leader>cO"] = actions.conflict_choose_all("ours"), -- Choose the OURS version of a conflict for the whole file
					["<leader>cT"] = actions.conflict_choose_all("theirs"), -- Choose the THEIRS version of a conflict for the whole file
					["<leader>cB"] = actions.conflict_choose_all("base"), -- Choose BASE versions of a conflict for the whole file
					["<leader>cA"] = actions.conflict_choose_all("all"), -- Choose all versions of a conflict for the whole file
					["dX"] = actions.conflict_choose_all("none"), -- Delete the conflict region for the whole file
				},
				file_history_panel = {
					["g!"] = cb("options"), -- Open the option panel
					["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
					["zR"] = cb("open_all_folds"),
					["zM"] = cb("close_all_folds"),
					["j"] = cb("next_entry"),
					["<down>"] = cb("next_entry"),
					["k"] = cb("prev_entry"),
					["<up>"] = cb("prev_entry"),
					["<cr>"] = cb("select_entry"),
					["o"] = cb("select_entry"),
					["<2-LeftMouse>"] = cb("select_entry"),
					["<C-j>"] = cb("select_next_entry"),
					["<C-k>"] = cb("select_prev_entry"),
					["gf"] = cb("goto_file"),
					["<C-w><C-f>"] = cb("goto_file_split"),
					["<C-w>gf"] = cb("goto_file_tab"),
					["<leader>e"] = cb("focus_files"),
					["<leader>b"] = cb("toggle_files"),
				},
				option_panel = { ["<tab>"] = cb("select"), ["q"] = cb("close") },
			},
		})
	end,
}
