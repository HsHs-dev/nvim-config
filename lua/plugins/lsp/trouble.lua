return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Workspace diagnostics" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<CR>",                  desc = "Document symbols" },
    { "<leader>xr", "<cmd>Trouble lsp toggle<CR>",                      desc = "LSP definitions/refs" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                   desc = "Location list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                    desc = "Quickfix list" },
    -- Navigate trouble items with [ ]
    {
      "[x",
      function()
        require("trouble").prev({ skip_groups = true, jump = true })
      end,
      desc = "Prev trouble item",
    },
    {
      "]x",
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
      desc = "Next trouble item",
    },
  },
  opts = {
    modes = {
      preview_float = {
        mode    = "diagnostics",
        preview = {
          type    = "float",
          relative = "editor",
          border  = "rounded",
          title   = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size    = { width = 0.4, height = 0.4 },
          zindex  = 200,
        },
      },
    },
  },
}
