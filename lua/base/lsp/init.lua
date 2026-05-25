if vim.fn.exists ':LspInfo' == 0 then
  vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', {
    desc = 'Alias to `:checkhealth vim.lsp`',
  })
end

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>l', group = '+LSP' },
    },
  },
  {
    'onsails/lspkind-nvim',
    lazy = false,
    init = function()
      require('lspkind').init {
        mode = 'symbol_text',
        preset = 'codicons',
        symbol_map = {
          Text = '󰉿',
          Method = '󰆧',
          Function = '󰊕',
          Constructor = '',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '',
          Property = '󰜢',
          Unit = '󰑭',
          Value = '󰎠',
          Enum = '',
          Keyword = '󰌋',
          Snippet = '',
          Color = '󰏘',
          File = '󰈙',
          Reference = '󰈇',
          Folder = '󰉋',
          EnumMember = '',
          Constant = '󰏿',
          Struct = '󰙅',
          Event = '',
          Operator = '󰆕',
          TypeParameter = '',
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'j-hui/fidget.nvim',
        config = true,
        tag = 'legacy',
        opts = {
          sources = {
            gopls = {
              ignore = true,
            },
          },
        },
      },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      servers = {},
      setup = {},
      format = {
        timeout_ms = 3000,
      },
    },
    config = function(plugin, opts)
      require('base.lsp.servers').setup(plugin, opts)
      vim.lsp.log.set_level 'error'
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      automatic_enable = {
        exclude = {
          'pyright',
          'pylsp',
          'rust_analyzer',
        },
      },
      -- ensure_installed = { 'lua_ls', 'rust_analyzer' },
    },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
  },
  {
    'RubixDev/mason-update-all',
    opts = {
      show_no_updates_notification = true,
    },
    config = function(_, opts)
      require('mason-update-all').setup(opts)
    end,
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'shfmt',
      },
      log_level = vim.log.levels.DEBUG,
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    event = 'BufReadPre',
    dependencies = { 'mason.nvim' },
    opts = function()
      local nls = require 'null-ls'
      return {
        root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
        sources = {
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
}
