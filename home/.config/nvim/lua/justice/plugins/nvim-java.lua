return {
	{
		"nvim-java/nvim-java",
		event = "VeryLazy",
		ft = "java",
		keys = {
			{
				"<leader>mr",
				function()
					--  Execute mvn compile silently (linux command) then :JavaRunnerRunMain
					vim.cmd("silent !mvn compile")
					vim.cmd("JavaRunnerRunMain")
				end,
				desc = "Compile the maven project and run",
			},
			{ "<leader>jr", ":JavaRunnerRunMain<CR>", desc = "Run the application or the selected main class" },
			{ "<leader>jl", ":JavaRunnerToggleLogs<CR>", desc = "Toggle runner logs" },
		},
	},
	{
		"eatgrass/maven.nvim",
		event = "VeryLazy",
		cmd = { "Maven", "MavenExec" },
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("maven").setup({
				executable = "mvn",
			})
		end,
	},
}
