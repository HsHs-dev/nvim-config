return {
	"karb94/neoscroll.nvim",
	event = "WinScrolled",
	opts = {
		mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
		hide_cursor = true,
		stop_eof = true,
		easing_function = "quadratic",
	},
}
