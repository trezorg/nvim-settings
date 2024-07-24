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
      { "<leader>fte", "<cmd>tabnew | Telescope file_browser<cr> hidden=true", desc = "Browse Files" },
      { "<leader>fe",  "<cmd>Telescope file_browser hidden=true<cr>",          desc = "Browse Files" },
      { "<leader>ff",  "<cmd>Telescope find_files hidden=true<cr>",            desc = "Find Files" },
      { "<leader>fg",  "<cmd>Telescope git_files<cr>",                         desc = "Git Files" },
      { "<leader>fb",  "<cmd>Telescope buffers<cr>",                           desc = "Buffers" },
      { "<leader>fh",  "<cmd>Telescope help_tags<cr>",                         desc = "Help" },
      { "<leader>sg",  "<cmd>Telescope live_grep<cr>",                         desc = "[S]earch by [G]rep" },
    },
    opts = {
      extensions = {
        file_browser = {
          theme = 'ivy',
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = false,
          hidden = { file_browser = true, folder_browser = true },
          respect_gitignore = true,
          -- browse_files = true,
          -- browse_folders = true,
        },
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
      defaults = {
        file_ignore_patterns = { ".git/", ".cache", "%.o", "%.a", "%.out", "%.class", "%.pdf", "%.mkv", "%.mp4",
          "%.zip", ".vscode/" },
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
        replace = { ['<leader>'] = 'SPC' },
        triggers = {
          { "<auto>", mode = "nxsot" },
        },
        win = {
          border = 'single', -- none, single, double, shadow
          -- position = 'bottom',      -- bottom, top
          -- margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          title_pos = 'center',     -- bottom, top
          -- winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3,                    -- spacing between columns
          align = 'left',                 -- align columns left, center or right
        },
      },
    },
    keys = {
      mode = { 'n', 'v' },
      { '<leader>f',  group = '+File' },
      { '<leader>q',  group = '+Quit/Session' },
      { '<leader>qq', '<cmd>q<cr>',           desc = 'Quit' },
      { '<leader>w',  '<cmd>update!<cr>',     desc = 'Save' },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts.setup)
      -- wk.add(opts.defaults)
    end,
  },
}
