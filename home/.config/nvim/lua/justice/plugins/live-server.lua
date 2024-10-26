return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
	config = true,
	keys = {
		{ "<leader>ls", "<cmd>LiveServerToggle<cr>", desc = "Toggle live server" },
	},
}
