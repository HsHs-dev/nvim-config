-- ============================================================
-- debug/nvim-dap.lua — Debug Adapter Protocol
-- Supported languages: C/C++ (codelldb), Python (debugpy)
-- Java: handled by nvim-jdtls automatically
-- ============================================================

return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "folke/neodev.nvim", "nvim-neotest/nvim-nio" },
      },
      -- Virtual text showing variable values inline
      "theHamsta/nvim-dap-virtual-text",
      -- Mason integration to auto-install debug adapters
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<F5>",       desc = "Debug: Start/Continue" },
      { "<F10>",      desc = "Debug: Step over" },
      { "<F11>",      desc = "Debug: Step into" },
      { "<F12>",      desc = "Debug: Step out" },
      { "<leader>db", desc = "Toggle breakpoint" },
      { "<leader>dB", desc = "Conditional breakpoint" },
      { "<leader>dr", desc = "Debug REPL" },
      { "<leader>dl", desc = "Run last" },
      { "<leader>du", desc = "Toggle DAP UI" },
      { "<leader>de", desc = "Evaluate expression", mode = { "n", "v" } },
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      -- ── DAP UI ──────────────────────────────────────────────
      dapui.setup({
        icons    = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand  = { "<CR>", "<2-LeftMouse>" },
          open    = "o",
          remove  = "d",
          edit    = "e",
          repl    = "r",
          toggle  = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks",      size = 0.30 },
              { id = "watches",     size = 0.20 },
            },
            size     = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size     = 12,
            position = "bottom",
          },
        },
        floating = {
          max_height  = nil,
          max_width   = nil,
          border      = "rounded",
          mappings    = { close = { "q", "<Esc>" } },
        },
      })

      -- Auto-open/close UI with debug sessions
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      -- ── Virtual text ─────────────────────────────────────────
      require("nvim-dap-virtual-text").setup({
        enabled                      = true,
        enabled_commands             = true,
        highlight_changed_variables  = true,
        highlight_new_as_changed     = false,
        show_stop_reason             = true,
        commented                    = false,
        virt_text_pos                = "eol",
        all_frames                   = false,
        virt_lines                   = false,
        virt_text_win_col            = nil,
      })

      -- ── C / C++ adapter (codelldb via Mason) ─────────────────
      -- codelldb is installed by mason-nvim-dap (ensure_installed below)
      local codelldb_path = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/adapter/codelldb"
      local liblldb_path = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"

      dap.adapters.codelldb = {
        type    = "server",
        port    = "${port}",
        executable = {
          command = codelldb_path,
          args    = { "--port", "${port}" },
        },
      }

      -- Default C/C++ launch config — edit as needed per project
      dap.configurations.c = {
        {
          name        = "Launch executable",
          type        = "codelldb",
          request     = "launch",
          program     = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
          args        = {},
        },
        {
          name    = "Attach to process",
          type    = "codelldb",
          request = "attach",
          pid     = require("dap.utils").pick_process,
          args    = {},
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- ── Python adapter (debugpy via Mason) ───────────────────
      local debugpy_path = vim.fn.stdpath("data")
        .. "/mason/packages/debugpy/venv/bin/python"

      dap.adapters.python = {
        type    = "executable",
        command = debugpy_path,
        args    = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type      = "python",
          request   = "launch",
          name      = "Launch file",
          program   = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then return venv .. "/bin/python" end
            return debugpy_path
          end,
        },
      }

      -- ── DAP signs ────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "●", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◉", texthl = "DapLogPoint",            linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped",             linehl = "DapStopped", numhl = "DapStopped" })
    end,
  },

  -- ── Mason-nvim-dap: auto-install debug adapters ───────────
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = {
        "codelldb",  -- C, C++, Rust
        "debugpy",   -- Python
        -- Java debugging is bundled with jdtls
      },
      handlers = {},  -- use default handler
    },
  },
}
