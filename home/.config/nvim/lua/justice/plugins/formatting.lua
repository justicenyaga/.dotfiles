return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		local format_on_save_enabled = true

		-- filetypes to disable format on save
		local format_on_save_disabled_filetypes = {}

		conform.setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				css = { "prettier" },
				go = { "goimports", "gofumpt" },
				graphql = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				python = { "isort", "black" },
				svelte = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			formatters = {
				prettier = {
					args = function(self, ctx)
						if vim.endswith(ctx.filename, ".ejs") then
							return { "--stdin-filepath", "$FILENAME", "--parser", "html" }
						end
						return { "--stdin-filepath", "$FILENAME" }
					end,
					range_args = function(self, ctx, range)
						if vim.endswith(ctx.filename, ".ejs") then
							return { "--stdin-filepath", "$FILENAME", "--parser", "html", "--range", range }
						end
						return { "--stdin-filepath", "$FILENAME", "--range", range }
					end,
				},
			},
			format_on_save = function()
				local is_file_disabled = vim.tbl_contains(format_on_save_disabled_filetypes, vim.bo.filetype)
				if not format_on_save_enabled or is_file_disabled then
					return
				else
					return {
						lsp_format = "fallback",
						async = false,
						timeout_ms = 1000,
					}
				end
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		vim.keymap.set("n", "<leader>tf", function()
			format_on_save_enabled = not format_on_save_enabled
			if format_on_save_enabled then
				vim.notify("Format on save enabled", vim.log.levels.INFO)
			else
				vim.notify("Format on save disabled", vim.log.levels.WARN)
			end
		end, { desc = "Toggle format on save" })
	end,
}
