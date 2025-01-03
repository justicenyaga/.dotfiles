return {
	"saghen/blink.cmp",
	version = "*",
	build = "cargo build --release",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"saghen/blink.compat",
		"onsails/lspkind.nvim",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		{
			"r5n-labs/vscode-react-javascript-snippets",
			build = "yarn install --frozen-lockfile && yarn compile",
		},
	},
	config = function()
		local luasnip = require("luasnip")

		-- Loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Add lorem ipsum snippets to all file types
		luasnip.filetype_extend("all", { "loremipsum" })

		require("blink-cmp").setup({
			snippets = {
				expand = function(snippets)
					luasnip.lsp_expand(snippets)
				end,
				active = function(filter)
					if filter and filter.direction then
						return luasnip.jumpable(filter.direction)
					end
					return luasnip.in_snippet()
				end,
				jump = function(direction)
					luasnip.jump(direction)
				end,
			},
			sources = {
				default = { "codeium", "lsp", "dadbod", "luasnip", "buffer", "path" },
				cmdline = {}, -- TODO: Remove this once cmdline completion has been fixed
				providers = {
					lsp = {
						name = "LSP",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						score_offset = 95,
					},
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
						score_offset = 70,
					},
					luasnip = {
						name = "Luasnip",
						module = "blink.cmp.sources.luasnip",
						score_offset = 0,
						max_items = 80,
					},
					codeium = {
						name = "codeium",
						enabled = false, -- TODO: Remove this once codeium source has been fixed
						module = "blink.compat.source",
						score_offset = 100,
						async = true,
					},
				},
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 150,
					window = {
						border = "rounded",
					},
				},
				accept = { auto_brackets = { enabled = true } },
				menu = {
					draw = {
						align_to = "cursor",
						treesitter = { "lsp" },
						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.item.source_name == "codeium" and "󱃖" or ctx.kind_icon
									return icon .. ctx.icon_gap
								end,
							},
						},
					},
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = {
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Struct = "󰙅",
					Value = "󰎠",
					Enum = "",
					EnumMember = "",
					Keyword = "󰌋",
					Constant = "󰏿",
					Reference = "󰈇",
					Operator = "󰆕",
				},
			},
			keymap = {
				preset = "default",
				["<C-n>"] = { "snippet_forward", "fallback" },
				["<C-p>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },

				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },

				["<C-c>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
			},
		})
	end,
	opts_extend = { "sources.default" },
}
