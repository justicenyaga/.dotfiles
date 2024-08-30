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
		config = function()
			local opts = { noremap = true, silent = true }

			opts.desc = "Toggle markdown preview"
			vim.keymap.set("n", "<leader>mdp", ":MarkdownPreview<CR>", opts) -- Start the preview

			opts.desc = "Stop markdown preview"
			vim.keymap.set("n", "<leader>mdx", ":MarkdownPreviewStop<CR>", opts) -- Stop the preview
		end,
	},
}
