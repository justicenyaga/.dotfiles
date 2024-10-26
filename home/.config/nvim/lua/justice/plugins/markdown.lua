return {
	{
		"iamcco/markdown-preview.nvim",
		event = "BufRead",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = "google-chrome-stable"
		end,
		keys = {
			{
				"<leader>mp",
				":MarkdownPreviewToggle<cr>",
				desc = "Toggle markdown preview",
			},
		},
	},
	{
		"hedyhli/markdown-toc.nvim",
		ft = "markdown",
		enabled = false,
		cmd = { "Mtoc" },
		opts = {
			toc_list = {
				item_format_string = "${indent}${marker} [[#${name}]]",
			},
		},
	},
}
