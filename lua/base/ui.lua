return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
    }
  }, {
  'nvim-tree/nvim-web-devicons',
  dependencies = { 'DaikyXendo/nvim-material-icon' },
  config = function()
    require('nvim-web-devicons').setup {
      -- override = require('nvim-material-icon').get_icons(),
    }
  end,
},
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1002,
    name = 'vscode',
    -- opts = {
    --   transparent = false,
    --   -- Enable italic comment
    --   italic_comments = true,
    --   -- Disable nvim-tree background color
    --   disable_nvimtree_bg = false,
    -- },
    -- config = function(_, opts)
    --   local vscode = require 'vscode'
    --   vscode.setup(opts)
    --   vscode.load()
    -- end,
  },
  {
    'doums/darcula',
    lazy = false,
    priority = 1005,
    name = 'darcula',
    init = function()
      vim.cmd [[colorscheme darcula]]
    end,
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1001,
    name = 'onedark',
    -- opts = {},
    -- config = function(_, opts)
    --   local onedark = require 'onedark'
    --   onedark.setup(opts)
    --   onedark.load()
    -- end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- opts = {
    --   style = 'night',
    --   transparent = false,
    --   styles = {
    --     sidebars = 'transparent',
    --     floats = 'transparent',
    --   },
    -- },
    -- config = function(_, opts)
    --   local tokyonight = require 'tokyonight'
    --   tokyonight.setup(opts)
    --   tokyonight.load()
    -- end,
  },
  { 'catppuccin/nvim', lazy = false, name = 'catppuccin' },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    event = 'VeryLazy',
    enabled = true,
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            find = '%d+L, %d+B',
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,            -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    },
    --stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",    desc = "Redirect Cmdline" },
      { "<c-f>",     function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true, expr = true,              desc = "Scroll forward" },
      { "<c-b>",     function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true,              desc = "Scroll backward" },
    },
  },
}
