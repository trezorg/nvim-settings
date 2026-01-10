return {
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-rhubarb' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  { 'mitsuhiko/vim-jinja', event = 'VeryLazy' },
  {
    'https://github.com/dstein64/nvim-scrollview',
    event = 'VeryLazy',
    lazy = false,
    config = true,
    opts = {
      excluded_filetypes = { 'neo-tree' },
      current_only = true,
      base = 'left',
      column = 1,
      signs_on_startup = { 'all' },
      diagnostics_severities = { vim.diagnostic.severity.WARN },
    },
  },
  -- {
  --   'echasnovski/mini.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   version = false,
  --   event = 'VeryLazy',
  --   config = function(_, _) -- opts
  --     require('mini.files').setup()
  --     vim.keymap.set('n', '<leader>fm', '<cmd>:lua MiniFiles.open()<CR>', { silent = true, desc = 'Open Minifile' })
  --     vim.keymap.set('n', '<leader>ftm', '<cmd>tabnew | :lua MiniFiles.open()<CR>',
  --       { silent = true, desc = 'Open Minifile new tab' })
  --     -- set termguicolors to enable highlight groups
  --     vim.opt.termguicolors = true
  --   end,
  -- },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
    },
    config = function()
      require('neo-tree').setup {
        close_if_last_window = false,
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        sort_case_insensitive = false,
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = '│',
            last_indent_marker = '└',
            highlight = 'NeoTreeIndentMarker',
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
          icon = {
            folder_closed = '',
            folder_open = '',
            folder_empty = '󰜌',
            default = '*',
            highlight = 'NeoTreeFileIcon',
          },
          modified = {
            symbol = '[+]',
            highlight = 'NeoTreeModified',
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = 'NeoTreeFileName',
          },
          git_status = {
            symbols = {
              added = '',
              modified = '',
              deleted = '✖',
              renamed = '󰁕',
              untracked = '',
              ignored = '',
              unstaged = '󰄱',
              staged = '',
              conflict = '',
            },
          },
        },
        window = {
          mappings = {
            ['<cr>'] = 'open_tabnew',
            ['l'] = 'open',
            ['s'] = 'open_vsplit',
            ['S'] = 'open_split',
            ['T'] = 'open_tabnew',
          },
        },
      }
    end,
  },
  {
    'crispgm/nvim-tabline',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
    opts = {
      show_index = true, -- show tab index
      show_modify = true, -- show buffer modification indicator
      show_icon = true, -- show file extension icon
      -- fnamemodify = ':p:.',        -- file name modifier
      fnamemodify = ':~:.', -- file name modifier
      modify_indicator = '[+]', -- modify indicator
      no_name = 'No name', -- no name buffer name
      brackets = { '[', ']' }, -- file name brackets surrounding
      inactive_tab_max_length = 0, -- max length of inactive tab titles, 0 to ignore
    },
  },
  { 'nvim-lua/plenary.nvim' },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit' },
    dependencies = {
      'tpope/vim-rhubarb',
    },
    -- stylua: ignore
    keys = {
      { "<leader>gs",  "<cmd>Git<cr>",               desc = "Status" },
      { "<leader>gb",  "<cmd>Git blame<cr>",         desc = "Blame" },
      { "<leader>gl",  "<cmd>Git log<cr>",           desc = "Log" },
      { "<leader>gdd", "<cmd>Git diff<cr>",          desc = "Diff" },
      { "<leader>gdc", "<cmd>Git diff --cached<cr>", desc = "Diff cached" },
    },
  },
  {
    'sindrets/diffview.nvim',
    lazy = false,
    keys = {
      { '<leader>gdvc', '<cmd>DiffviewClose<cr>', desc = 'Close DiffView' },
      { '<leader>gdvt', '<cmd>DiffviewToggleFiles<cr>', desc = 'DiffView toggle files' },
      { '<leader>gdvf', '<cmd>DiffviewFocusFiles<cr>', desc = 'DiffView focus files' },
      { '<leader>gdvf', '<cmd>DiffviewRefresh<cr>', desc = 'DiffView refresh' },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      {
        "<leader>qd",
        function() require("persistence").stop() end,
        desc =
        "Don't Save Current Session"
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>g', group = '+Git' },
      { '<leader>gd', group = '+Difw' },
      { '<leader>gdv', group = '+Diffview' },
      { '<leader>gdg', group = '+Mergetool' },
    },
  },
  {
    'trezorg/auto-save.nvim',
    event = 'VeryLazy',
    opts = {
      enabled = true,
      execution_message = {
        message = function() -- message to print on save
          return ('AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S')
        end,
        dim = 0.18, -- dim the color of `message`
        cleaning_interval = 100, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      },
      trigger_events = { 'InsertLeave', 'TextChanged' },
      -- trigger_events = { "InsertLeave" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'
        if fn.getbufvar(buf, '&modifiable') == 1 and utils.not_in(fn.getbufvar(buf, '&filetype'), {}) then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end,
      debounce_delay = 5000,
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      }
      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
      local keymap = vim.keymap.set
      keymap('n', '<leader>ftt', '<cmd>ToggleTerm direction=tab<cr>', { silent = true, desc = 'Open terminal tab mode' })
      keymap('n', '<leader>ftf', '<cmd>ToggleTerm direction=float<cr>', { silent = true, desc = 'Open terminal float mode' })
      keymap('n', '<leader>fth', '<cmd>ToggleTerm size=30 direction=horizontal<cr>', { silent = true, desc = 'Open terminal horizontal mode' })
      keymap('n', '<leader>ftv', '<cmd>ToggleTerm size=30 direction=vertical<cr>', { silent = true, desc = 'Open terminal vertical mode' })
    end,
  },
}
