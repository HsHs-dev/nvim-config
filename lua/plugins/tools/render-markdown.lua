return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    heading = {
      enabled = true,
      sign    = true,
      icons   = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled          = true,
      sign             = true,
      style            = "full",
      border           = "thin",
      above            = "▄",
      below            = "▀",
      highlight        = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
    },
    bullet = {
      enabled = true,
      icons   = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled   = true,
      unchecked = { icon = "󰄱 " },
      checked   = { icon = "󰱒 " },
    },
  },
}
