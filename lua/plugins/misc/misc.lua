return {
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  { "wakatime/vim-wakatime",    lazy = false },
  -- undotree (0.12 has :Undotree built-in via :packadd nvim.undotree
  -- but this plugin has better defaults and no packadd needed)
  {
    "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" } },
    config = function()
      vim.g.undotree_WindowLayout       = 2
      vim.g.undotree_SplitWidth         = 30
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
