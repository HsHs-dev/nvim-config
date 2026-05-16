-- ============================================================
-- jdtls.lua — Full Java IDE via nvim-jdtls
--
-- Why nvim-jdtls instead of bare lsp-config + jdtls?
-- • jdtls is stateful — each project needs its own workspace dir
-- • nvim-jdtls handles workspace isolation automatically
-- • Provides Java-specific code actions: organize imports,
--   extract method/variable/constant, move class, etc.
-- • Built-in DAP integration — no extra debug adapter needed
--
-- Prerequisites:
--   :MasonInstall jdtls google-java-format
--   Java 17+ must be installed (jdtls requires it)
--   For debugging: clone microsoft/java-debug and build it
--     see GUIDE.md section "Java-specific: Getting Debugging Working"
-- ============================================================

return {
  "mfussenegger/nvim-jdtls",
  ft = "java", -- only load on Java files
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls      = require("jdtls")
    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

    -- Find the equinox launcher jar (version-agnostic)
    local launcher_jar = vim.fn.glob(
      jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar",
      false, false
    )

    -- OS-specific config directory
    local os_config = "config_linux"
    if vim.fn.has("mac") == 1 then
      os_config = "config_mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "config_win"
    end

    -- Per-project workspace: prevents cross-project contamination
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

    -- Optional: java-debug adapter for DAP (build from source, see GUIDE.md)
    local bundles = {}
    local java_debug_jar = vim.fn.glob(
      vim.fn.expand("~") ..
      "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
      false, false
    )
    if java_debug_jar ~= "" then
      table.insert(bundles, java_debug_jar)
    end

    -- Optional: vscode-java-test for running/debugging tests
    local vscode_java_test = vim.fn.glob(
      vim.fn.expand("~") .. "/vscode-java-test/server/*.jar",
      false, true  -- return list
    )
    vim.list_extend(bundles, vscode_java_test)

    local config = {
      -- ── Command ──────────────────────────────────────────────
      cmd = {
        -- Point this to your actual java binary (java 17+)
        -- Check: which java  OR  echo $JAVA_HOME
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "-Xmx4g",              -- increase for large projects
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", jdtls_path .. "/" .. os_config,
        "-data", workspace_dir,
      },

      -- ── Root detection ────────────────────────────────────────
      root_dir = jdtls.setup.find_root({
        "pom.xml", "build.gradle", "build.gradle.kts",
        ".git", "mvnw", "gradlew",
      }),

      -- ── LSP settings ─────────────────────────────────────────
      settings = {
        java = {
          eclipse  = { downloadSources = true },
          maven    = { downloadSources = true },
          gradle   = { enabled = true },
          autobuild = { enabled = false },  -- manual builds are safer

          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.junit.Assert.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*", "io.micrometer.shaded.*",
              "java.awt.*", "jdk.*", "sun.*",
            },
            importOrder = { "java", "javax", "com", "org" },
          },

          format = {
            enabled  = true,
            settings = {
              -- Point to a custom Eclipse formatter XML if desired:
              -- url = "~/.config/nvim/java-formatter.xml",
              profile = "GoogleStyle",
            },
          },

          inlayHints = {
            parameterNames = { enabled = "all" },
          },

          saveActions = {
            organizeImports = true,
          },

          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },

          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = {
              -- Add your Java runtimes here; use :MasonInstall jdtls
              -- These are examples — adjust to your system:
              -- { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk-amd64/" },
              -- { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk-amd64/" },
            },
          },
        },
      },

      -- ── Capabilities (merged with nvim-cmp) ──────────────────
      capabilities = (function()
        local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        return has_cmp
          and cmp_lsp.default_capabilities()
          or vim.lsp.protocol.make_client_capabilities()
      end)(),

      -- ── DAP bundles ───────────────────────────────────────────
      init_options = {
        bundles = bundles,
      },

      -- ── On-attach keymaps ────────────────────────────────────
      on_attach = function(_, bufnr)
        -- Enable DAP if java-debug bundle loaded
        if #bundles > 0 then
          jdtls.setup_dap({ hotcodereplace = "auto" })
          jdtls.setup.add_commands()
        end

        local bmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        -- Java-specific refactoring (only available via nvim-jdtls)
        bmap("n", "<leader>co",  jdtls.organize_imports,                    "Organize imports")
        bmap("n", "<leader>crv", jdtls.extract_variable,                    "Extract variable")
        bmap("n", "<leader>crc", jdtls.extract_constant,                    "Extract constant")
        bmap("n", "<leader>crm", function() jdtls.extract_method(true) end, "Extract method")
        bmap("v", "<leader>crm", function() jdtls.extract_method(true) end, "Extract method")
        bmap("n", "<leader>cf",  jdtls.super_implementation,                "Go to super")

        -- Tests (requires vscode-java-test bundle)
        bmap("n", "<leader>jt",  jdtls.test_nearest_method, "Test nearest method")
        bmap("n", "<leader>jT",  jdtls.test_class,          "Test class")
        bmap("n", "<leader>jd",  jdtls.pick_test,           "Pick test to run")

        -- Build
        bmap("n", "<leader>jb", "<cmd>JdtCompile full<CR>",  "Full build")
        bmap("n", "<leader>jB", "<cmd>JdtCompile incremental<CR>", "Incremental build")
      end,
    }

    -- ── Start or reattach when switching to a java buffer ───────
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        jdtls.start_or_attach(config)
      end,
    })
  end,
}
