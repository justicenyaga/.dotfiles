return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	enabled = false,
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
		"brenoprata10/nvim-highlight-colors", -- for color suggestions
		-- es7/react/redux snippets
		{
			"dsznajder/vscode-es7-javascript-react-snippets",
			build = "yarn install --frozen-lockfile && yarn compile",
		},
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Add lorem ipsum snippets to all file types
		require("luasnip").filetype_extend("all", { "loremipsum" })

		-- Disable completion on certain file types
		local disabled_filetypes = { "gitcommit", "minifiles" }
		cmp.setup.filetype(disabled_filetypes, { enabled = false })

		cmp.setup({
			window = {
				documentation = cmp.config.window.bordered(),
				completion = {
					col_offset = -3,
					side_padding = 0,
				},
			},
			view = {
				entries = {
					follow_cursor = true,
				},
			},
			completion = {
				completeopt = "menu,menuone,preview,noinsert",
			},
			performance = {
				debounce = 0,
				throttle = 0,
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			matching = {
				disallow_partial_fuzzy_matching = false, -- Allow partial matching without prefix matching
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-c>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<C-y>"] = cmp.mapping.confirm({ select = false }),
				["<C-n>"] = cmp.mapping(function()
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-p>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "codeium" }, -- codeium
				-- { name = "copilot" }, -- copilot
				-- language server
				{
					name = "nvim_lsp",
					-- Filter out jsx snippets
					entry_filter = function(entry, _)
						local filetype = vim.bo.filetype
						local isJSX = filetype == "javascriptreact" or filetype == "typescriptreact"
						local isSnippet = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] == "Snippet"
						return not (isJSX and isSnippet)
					end,
				},
				{ name = "vim-dadbod-completion" },
				{ name = "luasnip", max_item_count = 5 }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local kind = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						symbol_map = {
							Copilot = "",
							Codeium = "󱃖",
						},
					})(entry, item)
					local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
					if color_item.abbr_hl_group then
						item.kind_hl_group = color_item.abbr_hl_group
						item.kind = color_item.abbr
					end

					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					item.kind = " " .. (strings[1] or "") .. " "
					item.menu = ""

					return item
				end,
			},
		})
	end,
}
