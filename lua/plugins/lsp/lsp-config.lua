-- ============================================================
-- lsp-config.lua — LSP setup for Neovim 0.12+
--
-- API: vim.lsp.config() + vim.lsp.enable()  ← the 0.12 standard
-- Diagnostic signs via vim.diagnostic.config() ← 0.12 required
--   (sign_define() for diagnostics is REMOVED in 0.12)
-- ============================================================

return {
  -- ── Mason: LSP/tool installer ──────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  -- ── Mason-LSPconfig bridge (v2 API) ───────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- v2: install handler is separate from ensure_installed
      ensure_installed = {
        -- Lua
        "lua_ls",
        -- C / C++
        "clangd",
        -- Java
        "jdtls",
        -- Python
        "pyright",
        -- Web
        "ts_ls",        -- TypeScript / JavaScript
        "html",
        "cssls",
        "jsonls",
        "emmet_ls",     -- HTML/CSS expansion
        -- Assembly & low-level
        "asm_lsp",
        -- Shell
        "bashls",
        -- Markdown / docs
        "marksman",
      },
      automatic_enable = false, -- we call vim.lsp.enable() ourselves below
    },
  },

  -- ── nvim-lspconfig + core LSP setup ───────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ── Capabilities (merge nvim-cmp's extra caps) ─────────
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = has_cmp
        and cmp_lsp.default_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

      -- Enable snippet support (needed for many servers)
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- ── Diagnostics (0.12 API — sign_define() is gone) ─────
      vim.diagnostic.config({
        virtual_text    = {
          prefix  = "●",
          spacing = 4,
        },
        signs = {
          text = {                           -- 0.12: must be a table with .text
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
          },
        },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float = {
          focusable = false,
          border    = "rounded",
          source    = true,
          header    = "",
          prefix    = "",
        },
      })

      -- ── Auto-show diagnostics on CursorHold ────────────────
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local diags = vim.diagnostic.get(0, {
            lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
          })
          if vim.tbl_isempty(diags) then return end

          -- Deduplicate
          local seen, unique = {}, {}
          for _, d in ipairs(diags) do
            if not seen[d.message] then
              unique[#unique + 1] = d
              seen[d.message]      = true
            end
          end

          vim.diagnostic.open_float(nil, {
            focusable    = false,
            close_events = { "BufLeave","CursorMoved","InsertEnter","FocusLost" },
            border       = "rounded",
            source       = true,
            scope        = "cursor",
            diagnostics  = unique,
          })
        end,
      })

      -- ── LSP keymaps (buffer-local on attach) ───────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bo = { buffer = ev.buf, silent = true }

          local function kmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", bo, { desc = desc }))
          end

          -- Navigation
          kmap("n", "gd",  vim.lsp.buf.definition,      "Go to definition")
          kmap("n", "gD",  vim.lsp.buf.declaration,     "Go to declaration")
          kmap("n", "gi",  vim.lsp.buf.implementation,  "Go to implementation")
          kmap("n", "gt",  vim.lsp.buf.type_definition, "Go to type definition")
          kmap("n", "K",   vim.lsp.buf.hover,           "Hover documentation")
          kmap("n", "gK",  vim.lsp.buf.signature_help,  "Signature help")
          kmap("i", "<C-k>", vim.lsp.buf.signature_help,"Signature help (insert)")

          -- Refactor
          kmap("n", "<leader>rn", vim.lsp.buf.rename,         "Rename symbol")
          kmap({ "n","v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- References (also available via Trouble)
          kmap("n", "gr", "<cmd>Telescope lsp_references<CR>",      "References")
          kmap("n", "gO", "<cmd>Telescope lsp_document_symbols<CR>","Document symbols")

          -- Diagnostics
          kmap("n", "<leader>D",  vim.diagnostic.open_float, "Line diagnostics")
          kmap("n", "]d",         vim.diagnostic.goto_next,  "Next diagnostic")
          kmap("n", "[d",         vim.diagnostic.goto_prev,  "Prev diagnostic")

          -- Workspace folders
          kmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,    "Add workspace folder")
          kmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          kmap("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")

          -- Inlay hints toggle (0.10+)
          if vim.lsp.inlay_hint then
            kmap("n", "<leader>ih", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- ── Per-server configuration ───────────────────────────
      -- Pattern: vim.lsp.config() sets options, vim.lsp.enable() starts it.
      -- nvim-lspconfig's require('lspconfig').SERVER.setup() still works
      -- but vim.lsp.config() is the 0.12 native way.

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              checkThirdParty = false,
              library         = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
            hint      = { enable = true },  -- inlay hints
          },
        },
      })

      -- C / C++ — clangd with all the important flags
      vim.lsp.config("clangd", {
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders  = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints          = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints  = true,
              includeInlayVariableTypeHints           = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints        = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints          = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints  = true,
              includeInlayVariableTypeHints           = true,
            },
          },
        },
      })

      -- Python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths        = true,
              diagnosticMode         = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode       = "basic",
            },
          },
        },
      })

      -- Emmet (HTML/CSS snippets)
      vim.lsp.config("emmet_ls", {
        capabilities = capabilities,
        filetypes = {
          "html","css","scss","javascript","javascriptreact",
          "typescript","typescriptreact","vue",
        },
      })

      -- JSON with schema support
      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
        -- schemastore.nvim provides hundreds of JSON schemas; see plugins/lsp/schemastore.lua
      })

      -- These use defaults + capabilities only
      local simple_servers = {
        "html", "cssls", "asm_lsp", "bashls", "marksman",
      }
      for _, server in ipairs(simple_servers) do
        vim.lsp.config(server, { capabilities = capabilities })
      end

      -- ── Enable all servers ─────────────────────────────────
      -- jdtls is handled by nvim-jdtls plugin (see tools/jdtls.lua)
      local all_servers = {
        "lua_ls", "clangd", "pyright", "ts_ls",
        "html", "cssls", "jsonls", "emmet_ls",
        "asm_lsp", "bashls", "marksman",
      }
      for _, server in ipairs(all_servers) do
        vim.lsp.enable(server)
      end
    end,
  },

  -- ── schemastore for JSON/YAML schemas ─────────────────────
  { "b0o/schemastore.nvim", lazy = true },
}
