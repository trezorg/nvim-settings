return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    opts = {
      sync_install = false,
      ensure_installed = {
        'bash',
        'dockerfile',
        'html',
        'markdown',
        'markdown_inline',
        'org',
        'query',
        'regex',
        'latex',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = { enable = true, additional_vim_regex_highlighting = { 'org', 'markdown' } },
      indent = { enable = true },
      context_commentstring = { enable = false, enable_autocmd = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
      -- matchup = {
      --   enable = true,
      -- },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          require('nvim-treesitter.parsers').org = {
            install_info = {
              url = 'https://github.com/milisims/tree-sitter-org',
              revision = 'main',
              queries = 'queries',
            },
          }
        end,
      })

      local ensure_installed = opts.ensure_installed
      opts.ensure_installed = nil

      if type(ensure_installed) == 'table' then
        ---@type table<string, boolean>
        local added = {}
        ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, ensure_installed)
      end

      -- require('nvim-treesitter.configs').setup(opts)
      local treesitter = require 'nvim-treesitter'
      treesitter.setup(opts)

      if type(ensure_installed) == 'table' then
        local available = treesitter.get_available()
        local installed = treesitter.get_installed 'parsers'
        local missing = vim.tbl_filter(function(lang)
          return vim.list_contains(available, lang) and not vim.list_contains(installed, lang)
        end, ensure_installed)

        if #missing > 0 then
          treesitter.install(missing)
        end
      end
    end,
  },
}
