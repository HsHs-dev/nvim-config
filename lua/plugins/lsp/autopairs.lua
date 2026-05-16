return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua        = { "string" },
        javascript = { "template_string" },
        java       = false, -- jdtls handles this
      },
      disable_filetype      = { "TelescopePrompt", "spectre_panel" },
      fast_wrap             = {
        map           = "<M-e>",
        chars         = { "{", "[", "(", '"', "'" },
        pattern       = [=[[%'%"%>%]%)%}%,]]=],
        end_key       = "$",
        before_key    = "p",
        after_key     = "n",
        cursor_pos_before = true,
        keys          = "qwertyuiopzxcvbnmasdfghjkl",
        highlight     = "Search",
        highlight_grey = "Comment",
      },
    })
    -- cmp integration: auto-add () after selecting function
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
