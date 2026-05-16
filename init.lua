-- ============================================================
-- init.lua — Neovim 0.12+ entry point
-- vim.uv replaces deprecated vim.loop (0.10+)
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options must load first so termguicolors is set before colorscheme
require("options")
-- Keymaps must load before lazy so <leader> is defined before plugins
require("keymaps")

require("lazy").setup({
  spec = {
    { import = "plugins.ui" },    -- Colorscheme, statusline, bufferline, indent guides
    { import = "plugins.lsp" },   -- LSP, completions, formatting, diagnostics
    { import = "plugins.tools" }, -- Telescope, Neo-tree, Git, Terminal
    { import = "plugins.debug" }, -- DAP debugging
    { import = "plugins.misc" },  -- Treesitter, which-key, motions, etc.
  },
  change_detection = { notify = false }, -- Don't spam on config change
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false }, -- Silent plugin update checks
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
