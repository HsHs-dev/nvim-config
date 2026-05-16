return {
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd  = "Telescope",
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<CR>",             desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>",             desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",              desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",                desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",              desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",               desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope grep_string<CR>",            desc = "Find word under cursor" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>",            desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",   desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>",  desc = "Workspace symbols" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",                desc = "Keymaps" },
      { "<leader>fG", "<cmd>Telescope git_commits<CR>",            desc = "Git commits" },
      { "<leader>fB", "<cmd>Telescope git_branches<CR>",           desc = "Git branches" },
      { "<leader>fR", "<cmd>Telescope resume<CR>",                 desc = "Resume last search" },
      { "<leader>f.", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>", desc = "Nvim config files" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = " ",
          path_display    = { "smart" },
          file_ignore_patterns = {
            "%.git/", "node_modules/", "%.cache/", "build/", "dist/",
            "%.class", "%.jar", "target/",
          },
          mappings = {
            i = {
              ["<C-k>"]     = actions.move_selection_previous,
              ["<C-j>"]     = actions.move_selection_next,
              ["<C-q>"]     = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"]     = actions.select_horizontal,
              ["<C-v>"]     = actions.select_vertical,
              ["<Esc>"]     = actions.close,
            },
            n = {
              ["q"]         = actions.close,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep  = {
            additional_args = function() return { "--hidden" } end,
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}
