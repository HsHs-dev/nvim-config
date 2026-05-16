return {
	"akinsho/toggleterm.nvim",
	version = "*",
	-- keys here serve double duty: lazy-load trigger AND the actual mapping
	-- every entry needs both lhs (key) AND rhs (command)
	keys = {
		{ "<C-\\>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },
		{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
		{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
	},
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4)
			end
		end,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 5,
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		-- Terminal window navigation (set here, not in keymaps.lua, so they
		-- only activate after toggleterm is loaded)
		local map = vim.keymap.set
		map("t", "<C-h>", "<C-\\><C-N><C-w>h", { silent = true })
		map("t", "<C-j>", "<C-\\><C-N><C-w>j", { silent = true })
		map("t", "<C-k>", "<C-\\><C-N><C-w>k", { silent = true })
		map("t", "<C-l>", "<C-\\><C-N><C-w>l", { silent = true })
		map("t", "<Esc>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

		-- Lazygit floating terminal
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			direction = "float",
			float_opts = { border = "curved" },
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})

		vim.keymap.set("n", "<leader>gg", function()
			lazygit:toggle()
		end, { desc = "Lazygit" })
	end,
}
