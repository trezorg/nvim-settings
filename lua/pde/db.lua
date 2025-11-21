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
      vim.list_extend(opts.ensure_installed, { 'sqlls', 'postgres-language-server' })
    end,
  },
  {
    'tpope/vim-dadbod',
    event = 'VeryLazy',
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
      vim.g.sql_type_default = 'pgsql'
      vim.g.vim_dadbod_completion_mark = ''
      vim.g.vim_dadbod_prefer_lowercase = 1
    end,
    cmd = { 'DBUIToggle', 'DBUI', 'DBUIAddConnection', 'DBUIFindBuffer', 'DBUIRenameBuffer', 'DBUILastQueryInfo' },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>D', group = '+Database' },
      { '<leader>Du', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI' },
      { '<leader>Df', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer' },
      { '<leader>Dr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer' },
      { '<leader>Dq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        sqlls = {
          cmd = { 'sql-language-server', 'up', '--method', 'stdio', '-d' },
          -- filetypes = { 'sql', 'mysql', 'psql' },
          filetypes = { 'psql' },
          root_dir = function()
            return vim.loop.cwd()
          end,
          settings = {
            sqlLanguageServer = {
              lint = {
                rules = {
                  ['align-column-to-the-first'] = 'error',
                  ['column-new-line'] = 'error',
                  ['linebreak-after-clause-keyword'] = 'error',
                  ['reserved-word-case'] = { 'error', 'lower' },
                  ['space-surrounding-operators'] = 'error',
                  ['where-clause-new-line'] = 'error',
                  ['align-where-clause-to-the-first'] = 'error',
                },
              },
            },
          },
        },
        postgres_lsp = {
          name = 'postgres_lsp',
          cmd = { 'postgres-language-server', 'lsp-proxy' },
          filetypes = { 'sql' },
          single_file_support = true,
          root_markers = { 'postgres-language-server.jsonc' },
          root_dir = function()
            return vim.loop.cwd()
          end,
        },
      },
    },
  },
}
