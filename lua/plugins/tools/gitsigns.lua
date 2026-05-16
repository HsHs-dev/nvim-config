return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text         = true,
      virt_text_pos     = "eol",
      delay             = 1000,
      ignore_whitespace = false,
    },
    on_attach = function(bufnr)
      local gs   = package.loaded.gitsigns
      local bmap = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      bmap("n", "]g", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, "Next hunk")

      bmap("n", "[g", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, "Prev hunk")

      -- Actions
      bmap("n", "<leader>gs",  gs.stage_hunk,         "Stage hunk")
      bmap("n", "<leader>gr",  gs.reset_hunk,         "Reset hunk")
      bmap("v", "<leader>gs",  function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, "Stage hunk")
      bmap("v", "<leader>gr",  function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, "Reset hunk")
      bmap("n", "<leader>gS",  gs.stage_buffer,       "Stage buffer")
      bmap("n", "<leader>gu",  gs.undo_stage_hunk,    "Unstage hunk")
      bmap("n", "<leader>gR",  gs.reset_buffer,       "Reset buffer")
      bmap("n", "<leader>gp",  gs.preview_hunk,       "Preview hunk")
      bmap("n", "<leader>gb",  function() gs.blame_line { full = true } end, "Blame line")
      bmap("n", "<leader>gB",  gs.toggle_current_line_blame, "Toggle blame")
      bmap("n", "<leader>gd",  gs.diffthis,           "Diff this")
      bmap("n", "<leader>gD",  function() gs.diffthis("~") end, "Diff against HEAD~")

      -- Text objects (select a hunk with ih/ah in visual/operator mode)
      bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Inner hunk")
      bmap({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "Outer hunk")
    end,
  },
}
