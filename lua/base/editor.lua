return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    cmd = 'Telescope',
    -- stylua: ignore
    keys = {
      { "<leader>fte", "<cmd>tabnew | Telescope file_browser<cr>", desc = "Browse Files" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "Browse Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
    opts = {
      extensions = {
        file_browser = {
          theme = 'ivy',
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = false,
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
      defaults = {
        mappings = {
          i = {
            ['<C-j>'] = function(...)
              require('telescope.actions').move_selection_next(...)
            end,
            ['<C-k>'] = function(...)
              require('telescope.actions').move_selection_previous(...)
            end,
            ['<C-n>'] = function(...)
              require('telescope.actions').cycle_history_next(...)
            end,
            ['<C-p>'] = function(...)
              require('telescope.actions').cycle_history_prev(...)
            end,
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension 'fzf'
      telescope.load_extension 'file_browser'
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      setup = {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ['<leader>'] = 'SPC' },
        triggers = 'auto',
        window = {
          border = 'single', -- none, single, double, shadow
          position = 'bottom', -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = 'left', -- align columns left, center or right
        },
      },
      defaults = {
        mode = { 'n', 'v' },
        ['<leader>f'] = { name = '+File' },
        ['<leader>q'] = { name = '+Quit/Session' },
        ['<leader>qq'] = { cmd = '<cmd>q<cr>', desc = 'Quit' },
        ['<leader>w'] = { cmd = '<cmd>update!<cr>', desc = 'Save' },
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts.setup)
      wk.register(opts.defaults)
    end,
  },
}
