-- custom highlight group for readonly variables
vim.api.nvim_create_autocmd("LspTokenUpdate", {
	callback = function(args)
		local token = args.data.token

		local readonly_variable_declaration = token.type == "variable"
			and token.modifiers.readonly
			and token.modifiers.declaration

		if readonly_variable_declaration then
			vim.lsp.semantic_tokens.highlight_token(
				token,
				args.buf,
				args.data.client_id,
				"@custom.readonly.declaration"
			)
		end
	end,
})

return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_colors = function(colors)
				colors.bg_highlight = "#143652"
				colors.bg_search = "#0A64AC"
				colors.bg_popup = "#011423"
				colors.bg_visual = "#275378"

				colors.black = "#152535"
				colors.red = "#FF3C3C"
				colors.green = "#49FF6D"
				colors.yellow = "#FFBC51"
				colors.blue = "#00AFFF"
				colors.magenta = "#8E44AD"
				colors.cyan = "#16A085"
				colors.fg_dark = "#BDC3C7"
				colors.terminal_black = "#56616D"
				colors.fg = "#ffffff"
			end,
			on_highlights = function(hl)
				hl["@custom.readonly.declaration"] = { fg = "#ffb0b0" }
				hl["@constant"] = { fg = "#ffb0b0" }
				hl["@tag"] = { fg = "#94bdff" }
				hl["@tag.delimiter"] = { fg = "#94bdff" }
			end,
		})

		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight]])
	end,
}

-- return {
--   "bluz71/vim-nightfly-guicolors",
--   priority = 1000, -- make sure to load this before all the other plugins start
--   name = "nightfly",
--   config = function()
--     --load the colorscheme here
--     vim.cmd([[colorscheme nightfly]])
--   end,
-- }
