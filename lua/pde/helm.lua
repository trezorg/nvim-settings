if not require('config').pde.helm then
  return {}
end

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'helm-ls' })
    end,
  },
  { 'towolf/vim-helm', lazy = false },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        helm_ls = {},
      },
      setup = {
        helm_ls = function(_, _)
          local configs = require 'lspconfig.configs'
          local lspconfig = require 'lspconfig'
          local util = require 'lspconfig.util'

          if not configs.helm_ls then
            configs.helm_ls = {
              default_config = {
                cmd = { 'helm_ls', 'serve' },
                filetypes = { 'helm' },
                root_dir = function(fname)
                  return util.root_pattern 'Chart.yaml'(fname)
                end,
              },
            }
          end

          lspconfig.helm_ls.setup {
            filetypes = { 'helm' },
            cmd = { 'helm_ls', 'serve' },
          }
        end,
      },
    },
  },
}
