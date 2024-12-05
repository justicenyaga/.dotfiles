local keymap = vim.keymap.set -- for conciseness

-- move cursor in insert mode
keymap("i", "<c-h>", "<left>", { desc = "move cursor to the left" })
keymap("i", "<c-j>", "<down>", { desc = "move cursor down" })
keymap("i", "<c-k>", "<up>", { desc = "move cursor up" })
keymap("i", "<c-l>", "<right>", { desc = "move cursor to the right" })

-- window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Move to window using <Ctrl> hjkl keys in terminal mode
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to lower window" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })

-- Resize window
keymap("n", "<C-up>", "<C-w>+", { desc = "Increase window height" })
keymap("n", "<C-down>", "<C-w>-", { desc = "Decrease window height" })
keymap("n", "<C-right>", "<c-w>>", { desc = "Increase window width" })
keymap("n", "<C-left>", "<c-w><", { desc = "Decrease window width" })

-- Tab management
keymap("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close all other tabs leaving the current" }) -- Make current tab the only tab
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- WakaTime
keymap("n", "<leader>ct", ":WakaTimeToday<cr>", { desc = "Echo today's coding time" })
