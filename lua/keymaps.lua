-- ============================================================
-- keymaps.lua
-- Legend: <leader> = Space
--         (n)ormal (i)nsert (v)isual (x)visual-block (t)erminal
-- ============================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── Leader ───────────────────────────────────────────────────
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Better escape ─────────────────────────────────────────────
map("i", "jk", "<ESC>", opts)
map("i", "kj", "<ESC>", opts)

-- ── Window navigation ─────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- ── Window resize ─────────────────────────────────────────────
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ── Buffer navigation ─────────────────────────────────────────
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", ":%bdelete|edit#|bdelete#<CR>", { desc = "Delete other buffers" })

-- ── File tree ─────────────────────────────────────────────────
map("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
map("n", "<leader>e", ":Neotree focus<CR>", { desc = "Focus Neo-tree" })
map("n", "<leader>E", ":Neotree reveal<CR>", { desc = "Reveal file in Neo-tree" })

-- ── Telescope (fuzzy finder) ──────────────────────────────────
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fG", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>fB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })

-- ── LSP (buffer-local via LspAttach autocmd in lsp-config.lua) ──
-- These are also set here as fallbacks (no-ops without LSP):
-- K          → hover docs
-- gd         → go to definition
-- gr         → references
-- gD         → go to declaration
-- <leader>ca → code action
-- <leader>rn → rename
-- [d / ]d    → prev/next diagnostic
-- <leader>D  → line diagnostics float

-- ── Diagnostics quick nav ─────────────────────────────────────
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "<leader>D", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ── Trouble (diagnostics panel) ───────────────────────────────
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>", { desc = "Document symbols" })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle<CR>", { desc = "LSP references/defs" })

-- ── Git (gitsigns — buffer-local in gitsigns config) ──────────
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
map("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Git blame full" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Unstage hunk" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff this" })
map("n", "]g", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next git hunk" })
map("n", "[g", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev git hunk" })

-- ── DAP (debugging) ───────────────────────────────────────────
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Debug: Start/Continue" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Debug: Step over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Debug: Step into" })
map("n", "<F12>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Debug: Step out" })
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map(
	"n",
	"<leader>dB",
	"<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>",
	{ desc = "Conditional breakpoint" }
)
map("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>", { desc = "Debug REPL" })
map("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "Run last" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })
map("n", "<leader>de", "<cmd>lua require('dapui').eval()<CR>", { desc = "Evaluate expression" })
map("v", "<leader>de", "<cmd>lua require('dapui').eval()<CR>", { desc = "Evaluate selection" })

-- ── Visual mode helpers ───────────────────────────────────────
map("v", "<", "<gv", opts) -- stay in indent mode
map("v", ">", ">gv", opts)
map("v", "p", '"_dP', opts) -- paste without overwriting register
map("v", "<A-j>", ":m .+1<CR>==", opts) -- move lines up/down
map("v", "<A-k>", ":m .-2<CR>==", opts)

-- ── Visual block mode ─────────────────────────────────────────
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- ── Editing utilities ─────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })
map("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlight" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

-- ── Formatting (conform) ──────────────────────────────────────
map({ "n", "v" }, "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file/selection" })

-- ── Quickfix & location lists ─────────────────────────────────
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
map("n", "[q", ":cprev<CR>", { desc = "Prev quickfix" })
map("n", "]l", ":lnext<CR>", { desc = "Next loclist" })
map("n", "[l", ":lprev<CR>", { desc = "Prev loclist" })

-- ── Plugin manager panels ─────────────────────────────────────
map("n", "<leader>mm", "<cmd>Mason<CR>", { desc = "Open Mason" })
map("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
map("n", "<leader>mu", "<cmd>MasonUpdate<CR>", { desc = "Update Mason tools" })

-- ── Splits ───────────────────────────────────────────────────
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

-- ── Misc ─────────────────────────────────────────────────────
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Undo tree" })
