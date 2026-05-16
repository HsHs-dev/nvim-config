-- ============================================================
-- completions.lua
-- CRITICAL FIX from original: { name = "nvim_lsp" } was missing
-- from cmp sources, meaning LSP completions weren't working at all.
-- ============================================================

return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",   -- LSP completions ← was missing from sources
    "hrsh7th/cmp-buffer",     -- buffer word completions
    "hrsh7th/cmp-path",       -- filesystem path completions
    "hrsh7th/cmp-cmdline",    -- command-line completions
    "saadparwaiz1/cmp_luasnip",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build   = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
  },
  config = function()
    local cmp     = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    local kind_icons = {
      Text          = "󰊄",  Method        = "󰊕",  Function      = "󰊕",
      Constructor   = "",  Field         = "",  Variable      = "󰫧",
      Class         = "",  Interface     = "",  Module        = "",
      Property      = "",  Unit          = "",  Value         = "",
      Enum          = "",  Keyword       = "󰌆",  Snippet       = "",
      Color         = "",  File          = "",  Reference     = "",
      Folder        = "",  EnumMember    = "",  Constant      = "",
      Struct        = "",  Event         = "",  Operator      = "",
      TypeParameter = "󰉺",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion    = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-j>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- only confirm explicit selection
        ["<Tab>"]     = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)
          item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip  = "[Snip]",
            buffer   = "[Buf]",
            path     = "[Path]",
          })[entry.source.name]
          -- Truncate long completion items
          local MAX = 40
          if #item.abbr > MAX then
            item.abbr = item.abbr:sub(1, MAX) .. "…"
          end
          return item
        end,
      },
      -- ── Sources: ORDER = priority ──────────────────────────
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 }, -- ← THE FIX
        { name = "luasnip",  priority = 750  },
        { name = "path",     priority = 500  },
      }, {
        { name = "buffer",   priority = 250, keyword_length = 3 },
      }),
      experimental = {
        ghost_text = { hl_group = "Comment" }, -- ghost text preview
      },
    })

    -- ── Cmdline completions ────────────────────────────────
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" } }
      ),
    })
  end,
}
