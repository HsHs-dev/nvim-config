return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	keys = {
		{ "<leader>ls", "<cmd>LiveServerStart<cr>", desc = "Live server start" },
		{ "<leader>lS", "<cmd>LiveServerStop<cr>", desc = "Live server stop" },
	},
	config = false, -- no setup() call
	init = function()
		vim.g.live_server = {
			port = 5500,
			browser = "default",
		}
	end,
}
