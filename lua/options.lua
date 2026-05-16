-- ============================================================
-- options.lua — editor behaviour, 0.12-aware
-- ============================================================

local opt = vim.opt

-- ── File & persistence ────────────────────────────────────────
opt.backup = false
opt.swapfile = false
opt.undofile = true -- persistent undo across sessions
opt.writebackup = false
opt.fileencoding = "utf-8"

-- ── Search ───────────────────────────────────────────────────
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true -- override ignorecase when uppercase typed

-- ── UI ───────────────────────────────────────────────────────
opt.termguicolors = true -- REQUIRED: was commented out in old config
opt.cmdheight = 1 -- 1 is fine with fidget.nvim for LSP messages
opt.pumheight = 12
opt.showmode = false -- lualine shows mode already
opt.showtabline = 2 -- always show tabline (bufferline uses this)
opt.cursorline = true
opt.signcolumn = "yes"
opt.winborder = "rounded" -- 0.11+: default border for ALL floating windows
--        replaces per-plugin border settings

-- ── Layout & navigation ──────────────────────────────────────
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.mouse = "a"

-- ── Indentation & completion ─────────────────────────────────
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 250 -- faster CursorHold / gitsigns

-- ── Clipboard & display ──────────────────────────────────────
opt.clipboard = "unnamedplus"
opt.conceallevel = 0 -- show `` in markdown
opt.list = false -- show invisible chars
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- ── Numbers ──────────────────────────────────────────────────
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- ── Timing ───────────────────────────────────────────────────
opt.timeoutlen = 500 -- 500 ms feels snappy for which-key

-- ── Folds (Treesitter-powered) ───────────────────────────────
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- 0.12 native TS fold
opt.foldlevel = 99 -- open all folds on file open
opt.foldlevelstart = 99

-- ── Diff ─────────────────────────────────────────────────────
opt.diffopt:append("indent-heuristic,algorithm:histogram")

-- ── Misc ─────────────────────────────────────────────────────
opt.shortmess:append("c") -- don't show completion messages
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])

-- ── Neovim 0.12 native autocomplete (optional, we use nvim-cmp) ──
-- vim.o.autocomplete = true   -- uncomment to try native completion
