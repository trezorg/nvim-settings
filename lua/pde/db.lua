if not require('config').pde.db then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'sql' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'sqlls' })
    end,
  },
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      local function db_completion()
        require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
      end
      vim.g.db_ui_save_location = vim.fn.stdpath 'config' .. require('plenary.path').path.sep .. 'db_ui'

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          '*.sql',
        },
        command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          '*.sql',
          '*.mysql',
          '*.plsql',
        },
        callback = function()
          vim.schedule(db_completion)
        end,
      })
    end,
    cmd = { 'DBUIToggle', 'DBUI', 'DBUIAddConnection', 'DBUIFindBuffer', 'DBUIRenameBuffer', 'DBUILastQueryInfo' },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      defaults = {
        ['<leader>D'] = { name = '+Database' },
        ['<leader>Du'] = { cmd = '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI' },
        ['<leader>Df'] = { cmd = '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer' },
        ['<leader>Dr'] = { cmd = '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer' },
        ['<leader>Dq'] = { cmd = '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info' },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        sqlls = {},
      },
    },
  },
}
