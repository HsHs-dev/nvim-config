-- Flash: type a label to jump anywhere on screen
-- s        → flash jump (normal/visual/operator)
-- S        → flash treesitter (jump to TS node)
-- r        → remote flash (in operator-pending)
-- R        → treesitter search
-- <C-s>    → toggle flash in search /
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        enabled = true,   -- flash highlights while typing /
      },
      char = {
        enabled   = true, -- enhanced f/t/F/T
        jump_labels = false,
      },
    },
    label = {
      rainbow   = { enabled = true, shade = 5 },
      uppercase = false,
    },
  },
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash jump" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter search" },
    { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash search" },
  },
}
