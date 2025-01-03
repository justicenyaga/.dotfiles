return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
		},
		config = function()
			local api = require("typescript-tools.api")

			require("typescript-tools").setup({
				handlers = {
					["textDocument/publishDiagnostics"] = api.filter_diagnostics({
						80001, -- Ignore this might be converted to a ES export
					}),
				},
				settings = {
					expose_as_code_action = "all",
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				on_attach = function(config, bufnr)
					local keymap = vim.keymap.set

					keymap(
						{ "n", "v" },
						"<leader>io",
						":TSToolsOrganizeImports<CR>",
						{ desc = "Organize Imports (Sort and Remove Unused Imports)", silent = true, buffer = bufnr }
					)

					keymap(
						{ "n", "v" },
						"<leader>is",
						":TSToolsSortImports<CR>",
						{ desc = "Imports Sort", silent = true, buffer = bufnr }
					)

					keymap({ "n", "v" }, "<leader>ir", ":TSToolsRemoveUnusedImports<CR>", {
						desc = "Remove Unused Imports",
						silent = true,
						buffer = bufnr,
					})

					keymap({ "n", "v" }, "<leader>ia", ":TSToolsAddMissingImports<CR>", {
						desc = "Add Missing Imports",
						silent = true,
						buffer = bufnr,
					})

					keymap(
						{ "n", "v" },
						"<leader>rf",
						":TSToolsRenameFile<CR>",
						{ desc = "Rename File", silent = true, buffer = bufnr }
					)
				end,
			})
		end,
	},

	{
		"dmmulroy/tsc.nvim",
		cmd = { "TSC" },
		opts = {
			auto_close_qflist = true,
			auto_focus_qflist = true,
			use_trouble_qflist = true,
		},
	},
}
