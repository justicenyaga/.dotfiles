return {
	-- "hrsh7th/nvim-cmp",
	"yioneko/nvim-cmp",
	enabled = false,
	branch = "perf",
	event = { "InsertEnter", "CmdlineEnter" },
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

		cmp.setup({
			window = {
				documentation = cmp.config.window.bordered(),
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
				max_view_entries = 10,
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
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
				-- { name = "codeium" },
				-- { name = "copilot" }, -- copilot
				{ name = "nvim_lsp" }, -- language server
				{ name = "vim-dadbod-completion" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = function(entry, item)
					item = lspkind.cmp_format({
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
					return item
				end,
			},
		})
	end,
}
