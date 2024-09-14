return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "Deez Notes",
					path = "~/obsidian",
				},
			},

			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",

			daily_notes = {
				folder = "dailies",
			},

			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M:%S",
			},

			---@param url string
			follow_url_func = function(url)
				vim.fn.jobstart({ "xdg-open", url })
			end,

			---@param title string|?
			---@return string
			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end

				return tostring(os.date("%Y-%m-%d")) .. "_" .. suffix
			end,

			disable_frontmatter = true,

			ui = {
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				},
			},
		})

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>on", ":ObsidianNew<cr>", { desc = "Create new note" })
		keymap.set("n", "<leader>ot", ":ObsidianTemplate note<cr>", { desc = "Apply note template on current buffer" })
		keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", { desc = "Format title under cursor" })

		keymap.set("n", "<leader>ok", ":!mv '%:p' ~/obsidian/review/<cr>:bd<cr>")
		keymap.set("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")

		keymap.set("n", "<leader>oc", ":!oc<cr>", { silent = true, desc = "Commit a staged obsidian note" })
	end,
}
