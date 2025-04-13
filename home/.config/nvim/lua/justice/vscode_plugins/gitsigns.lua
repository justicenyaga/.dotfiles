return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	config = function()
		require("gitsigns").setup({
			preview_config = {
				border = "rounded",
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				-- move to the next hunk
				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Move to the next hunk" })

				-- move to the previous hunk
				map("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Move to the previous hunk" })

				-- Actions
				map("n", "<leader>gA", gs.stage_hunk, { desc = "Stage hunk under cursor" })
				map("n", "<leader>gR", gs.reset_hunk, { desc = "Reset hunk under cursor" })
				map("v", "<leader>gA", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage selected hunk" })
				map("v", "<leader>gR", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset selected hunk" })
				map("n", "<leader>gU", gs.undo_stage_hunk, { desc = "Unstage last staged hunk" })
				map("n", "<leader>gv", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>gm", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame hunk under cursor" })
				map("n", "<leader>gM", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
				map("n", "<leader>gD", gs.toggle_deleted, { desc = "Toggle deleted lines" })

				-- Text objects
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
			end,
		})
	end,
}
