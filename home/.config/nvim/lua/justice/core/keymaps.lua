-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap.set -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Select All
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- Horizontal scroll
keymap("n", "<left>", "zH", { desc = "Scroll left" })
keymap("n", "<right>", "zL", { desc = "Scroll right" })

-- increment/decrement numbers
keymap("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
keymap("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Quickfix
keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Find and Replace Keymap
keymap("n", "<leader>fr", ":%s//gc<Left><Left><Left>", { desc = "Find and Replace" })
keymap("n", "<leader>fR", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Find and replace word under cursor" })

if vim.g.vscode then
	require("justice.core.vscode_keymaps")
else
	require("justice.core.native_keymaps")
end
