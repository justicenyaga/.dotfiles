return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		-- Import harpoon plugin.
		local harpoon = require("harpoon")
		local keymap = vim.keymap -- for conciseness.
		-- Required:
		harpoon:setup()
		-- Keymaps:
		keymap.set("n", "ma", function()
			harpoon:list():add()
		end, { desc = "Add current file to harpoon list" })
		keymap.set("n", "mm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list(), {
				border = "rounded",
				title_pos = "center",
				ui_width_ratio = 0.5,
			})
		end, { desc = "Toggle open/close of harpoon list" })
		keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end, { desc = "Go the next marked file in the harpoon list" })
		keymap.set("n", "<C-p>", function()
			harpoon:list():prev()
		end, { desc = "Go the previous marked file in the harpoon list" })
		keymap.set("n", "m1", function()
			harpoon:list():select(1)
		end, { desc = "Open 1st harpoon mark" })
		keymap.set("n", "m2", function()
			harpoon:list():select(2)
		end, { desc = "Open 2nd harpoon mark" })
		keymap.set("n", "m3", function()
			harpoon:list():select(3)
		end, { desc = "Open 3rd harpoon mark" })
		keymap.set("n", "m4", function()
			harpoon:list():select(4)
		end, { desc = "Open 4th harpoon mark" })
		keymap.set("n", "m5", function()
			harpoon:list():select(5)
		end, { desc = "Open 5th harpoon mark" })
		keymap.set("n", "ms", function()
			harpoon:list():select(6)
		end, { desc = "Open 6th harpoon mark" })
		keymap.set("n", "md", function()
			harpoon:list():select(7)
		end, { desc = "Open 7th harpoon mark" })
		keymap.set("n", "mf", function()
			harpoon:list():select(8)
		end, { desc = "Open 8th harpoon mark" })
	end,
}
