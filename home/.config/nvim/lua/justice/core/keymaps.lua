-- set leader key to space
vim.g.mapleader = " "

local set = vim.keymap.set -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
set("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Select All
set("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- increment/decrement numbers
set("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
set("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Resize window
set("n", "<C-up>", "<C-w>+", { desc = "Increase window height" })
set("n", "<C-down>", "<C-w>-", { desc = "Decrease window height" })
set("n", "<C-right>", "<c-w>>", { desc = "Increase window width" })
set("n", "<C-left>", "<c-w><", { desc = "Decrease window width" })

-- Tab management
set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close all other tabs leaving the current" }) -- Make current tab the only tab
set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Quickfix
set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Find and Replace Keymap
set("n", "<leader>fr", ":%s//gc<Left><Left><Left>", { desc = "Find and Replace" })
set("n", "<leader>fR", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Find and replace word under cursor" })

-- WakaTime
set("n", "<leader>ct", ":WakaTimeToday<cr>", { desc = "Echo today's coding time" })
