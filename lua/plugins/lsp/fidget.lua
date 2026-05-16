return {
  "j-hui/fidget.nvim",
  tag  = "legacy",  -- stable tag
  event = "LspAttach",
  opts = {
    text = {
      spinner       = "dots",
      done          = "✓",
      commenced     = "Started",
      completed     = "Completed",
    },
    align = { bottom = true },
    window = {
      relative    = "win",
      blend       = 10,
      zindex      = nil,
      border      = "none",
    },
  },
}
