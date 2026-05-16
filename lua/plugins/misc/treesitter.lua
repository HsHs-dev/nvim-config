-- ============================================================
-- treesitter.lua — 0.12 compatible
--
-- In Neovim 0.12 / new nvim-treesitter (main branch):
-- • nvim-treesitter is now a PARSER DOWNLOAD UTILITY only
-- • Treesitter highlighting is configured via vim.treesitter
-- • The old config.setup({ highlight = { enable = true } })
--   still works but module system is being phased out
-- • Folding now uses vim.treesitter.foldexpr() natively (set in options.lua)
-- ============================================================

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			-- Treesitter text objects (structural selection)
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					-- Languages you develop in
					"c",
					"cpp", -- C / C++
					"lua", -- Neovim config
					"python", -- Python
					"java", -- Java
					"javascript",
					"typescript",
					"tsx", -- Web JS/TS
					"html",
					"css", -- Web markup/style
					"json",
					"jsonc", -- JSON
					"yaml",
					"toml", -- Config files
					"bash", -- Shell scripts
					"asm", -- Assembly
					"markdown",
					"markdown_inline", -- Docs
					"vim",
					"vimdoc", -- Vim help files
					"query", -- Treesitter queries
					"regex", -- Regex in code
					"diff", -- Diff/patch files
					"gitignore",
					"git_config",
					"git_rebase",
					"dockerfile",
					"make", -- Makefiles
					"cmake", -- CMake
					"xml", -- XML/SVG
					"http", -- HTTP files (REST)
					"sql", -- SQL queries
				},

				-- Auto-install missing parsers on file open
				auto_install = true,

				highlight = {
					enable = true,
					-- Disable for very large files (performance)
					disable = function(_, buf)
						local max_lines = 5000
						return vim.api.nvim_buf_line_count(buf) > max_lines
					end,
					-- Don't double-highlight with vim regex
					additional_vim_regex_highlighting = false,
				},

				indent = { enable = true },

				-- ── Text objects (requires nvim-treesitter-textobjects) ──
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- jump forward to next text object
						keymaps = {
							-- Functions
							["af"] = { query = "@function.outer", desc = "Select outer function" },
							["if"] = { query = "@function.inner", desc = "Select inner function" },
							-- Classes
							["ac"] = { query = "@class.outer", desc = "Select outer class" },
							["ic"] = { query = "@class.inner", desc = "Select inner class" },
							-- Conditionals
							["ai"] = { query = "@conditional.outer", desc = "Select outer if/else" },
							["ii"] = { query = "@conditional.inner", desc = "Select inner if/else" },
							-- Loops
							["al"] = { query = "@loop.outer", desc = "Select outer loop" },
							["il"] = { query = "@loop.inner", desc = "Select inner loop" },
							-- Parameters / arguments
							["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
							["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },
							-- Block
							["ab"] = { query = "@block.outer", desc = "Select outer block" },
							["ib"] = { query = "@block.inner", desc = "Select inner block" },
							-- Comments
							["a/"] = { query = "@comment.outer", desc = "Select comment" },
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- add to jumplist
						goto_next_start = {
							["]f"] = { query = "@function.outer", desc = "Next function start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							["]F"] = { query = "@function.outer", desc = "Next function end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@function.outer", desc = "Prev function start" },
							["[c"] = { query = "@class.outer", desc = "Prev class start" },
						},
						goto_previous_end = {
							["[F"] = { query = "@function.outer", desc = "Prev function end" },
							["[C"] = { query = "@class.outer", desc = "Prev class end" },
						},
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>na"] = "@parameter.inner" },
						swap_previous = { ["<leader>pa"] = "@parameter.inner" },
					},
				},
			})
		end,
	},
}
