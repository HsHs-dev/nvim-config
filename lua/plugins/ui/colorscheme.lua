return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- load before everything else
  opts = {
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
    },
    on_highlights = function(hl, c)
      -- Sharper line number column
      hl.LineNr = { fg = c.dark5 }
      hl.CursorLineNr = { fg = c.orange, bold = true }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
