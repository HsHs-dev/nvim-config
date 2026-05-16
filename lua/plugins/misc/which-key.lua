return {
  "folke/which-key.nvim",
  event  = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      delay   = 400,    -- ms before popup appears
      icons   = { separator = "→" },
      plugins = {
        marks      = true,
        registers  = true,
        spelling   = { enabled = true, suggestions = 15 },
        presets    = {
          operators    = true,
          motions      = true,
          text_objects = true,
          windows      = true,
          nav          = true,
          z            = true,
          g            = true,
        },
      },
    })

    -- Register group prefixes so which-key shows labels
    wk.add({
      { "<leader>f",  group = "Find/Telescope" },
      { "<leader>l",  group = "LSP" },
      { "<leader>g",  group = "Git" },
      { "<leader>d",  group = "Debug" },
      { "<leader>x",  group = "Trouble/Diagnostics" },
      { "<leader>t",  group = "Terminal" },
      { "<leader>s",  group = "Splits" },
      { "<leader>b",  group = "Buffers" },
      { "<leader>w",  group = "Workspace" },
      { "<leader>r",  group = "Refactor" },
      { "<leader>m",  group = "Mason" },
    })
  end,
}
