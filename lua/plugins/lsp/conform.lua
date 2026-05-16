return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  keys  = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format file / selection",
    },
  },
  opts = {
    formatters_by_ft = {
      -- Lua
      lua = { "stylua" },
      -- Python
      python = { "isort", "black" },
      -- Web
      javascript      = { "prettierd", "prettier", stop_after_first = true },
      typescript      = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      html            = { "prettierd", "prettier", stop_after_first = true },
      css             = { "prettierd", "prettier", stop_after_first = true },
      scss            = { "prettierd", "prettier", stop_after_first = true },
      json            = { "prettierd", "prettier", stop_after_first = true },
      yaml            = { "prettierd", "prettier", stop_after_first = true },
      markdown        = { "prettierd", "prettier", stop_after_first = true },
      -- C / C++
      c   = { "clang_format" },
      cpp = { "clang_format" },
      -- Java
      java = { "google_java_format" },
      -- Assembly
      asm = { "asmfmt" },
      s   = { "asmfmt" },
      -- Shell / Bash ← NEW
      sh   = { "shfmt" },
      bash = { "shfmt" },
      zsh  = { "shfmt" },
    },
    format_on_save = {
      lsp_fallback = true,
      async        = false,
      timeout_ms   = 1000, -- bumped from 500 — java/clangd can be slow
    },
    -- Formatter-specific options
    formatters = {
      shfmt = {
        args = { "-i", "2", "-ci" }, -- 2-space indent, switch-case indent
      },
      clang_format = {
        args = { "--style=file", "--fallback-style=LLVM" },
      },
    },
  },
}
