return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")

		mc.setup()

		local set = vim.keymap.set -- for conciseness

		set({ "n", "v" }, "<M-k>", function()
			mc.lineAddCursor(-1)
		end, { desc = "Add cursor above the main cursor" }) -- skipping empty lines
		set({ "n", "v" }, "<M-j>", function()
			mc.lineAddCursor(1)
		end, { desc = "Add cursor below the main cursor" })
		set({ "n", "v" }, "<M-K>", function()
			mc.lineSkipCursor(-1)
		end, { desc = "Move only the main cursor up a line" })
		set({ "n", "v" }, "<M-J>", function()
			mc.lineSkipCursor(1)
		end, { desc = "Move only the main cursor down a line" })

		set({ "n", "v" }, "<M-n>", function()
			mc.matchAddCursor(1)
		end, { desc = "Add cursor to next matching word/selection" })
		set({ "n", "v" }, "<M-p>", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add cursor to prev matching word/selection" })
		set({ "n", "v" }, "<M-N>", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip adding next matching word/selection" })
		set({ "n", "v" }, "<M-P>", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Skip adding prev matching word/selection" })

		set({ "n", "v" }, "<M-a>", mc.matchAllAddCursors, { desc = "Add cursor on all matching words/selection" })

		-- Rotate the main cursor.
		set({ "n", "v" }, "<M-l>", mc.nextCursor, { desc = "Select the cursor after the main cursor" })
		set({ "n", "v" }, "<M-h>", mc.prevCursor, { desc = "Select the cursor before the main cursor" })
		set({ "n", "v" }, "<M-m>", mc.firstCursor, { desc = "Select the first cursor" })
		set({ "n", "v" }, "<M-M>", mc.lastCursor, { desc = "Select the last cursor" })

		set({ "n", "v" }, "<M-x>", mc.deleteCursor, { desc = "Delete the main cursor" })

		set("n", "<M-leftmouse>", mc.handleMouse, { desc = "Toggle cursor using ctrl + left click" })

		-- Easy way to add and remove cursors using the main cursor.
		set({ "n", "v" }, "<M-space>", mc.toggleCursor, { desc = "Toggle a cursor under main & disable cursors" }) -- Disables all cursors expect main cursor. Disabled cursors don't move until unlocked.

		set({ "n", "v" }, "<M-y>", mc.duplicateCursors, { desc = "Duplicate cursors, disabling the originals" })

		set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors() -- unlock disabled cursors
			elseif mc.hasCursors() then
				mc.clearCursors() -- clear all cursors (except main)
			else
				vim.cmd("nohl") -- clear search highlight
			end
		end)

		set("n", "<M-r>", mc.restoreCursors, { desc = "Restore cleared cursors" })

		set("n", "<M-tab>", mc.alignCursors, { desc = "Align cursor columns" })

		set("v", "S", mc.splitCursors, { desc = "Split visual selections by regex" })

		-- Append/insert for each line of visual selections.
		set("v", "I", mc.insertVisual)
		set("v", "A", mc.appendVisual)

		set("v", "M", mc.matchCursors, { desc = "Match new cursors within visual selections by regex" })

		set("v", "<M-t>", function()
			mc.transposeCursors(1)
		end, { desc = "Rotate visual selection content with next selection" })
		set("v", "<M-T>", function()
			mc.transposeCursors(-1)
		end, { desc = "Rotate visual selection content with prev selection" })

		-- Jumplist support
		set({ "v", "n" }, "<c-i>", mc.jumpForward)
		set({ "v", "n" }, "<c-o>", mc.jumpBackward)

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { link = "Cursor" })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
