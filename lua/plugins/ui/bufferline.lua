return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  keys = {
    { "<S-l>",     "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<S-h>",     "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",   desc = "Pin buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " " }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype   = "neo-tree",
          text       = "File Explorer",
          highlight  = "Directory",
          separator  = true,
        },
      },
      show_buffer_close_icons = true,
      show_close_icon         = false,
      separator_style         = "slant",
      always_show_bufferline  = false,
    },
  },
}
