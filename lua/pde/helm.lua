if not require('config').pde.helm then
  return {}
end

local function set_yaml_for_helm_files()
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*/templates/*.yaml', '*/templates/*.tpl', '*.gotmpl', 'helmfile*.yaml' },
    callback = function()
      vim.opt_local.filetype = 'helm'
    end
  })
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
                  return util.root_pattern 'Chart.yaml' (fname)
                end,
              },
            }
          end

          set_yaml_for_helm_files()

          lspconfig.helm_ls.setup {
            filetypes = { 'helm' },
            cmd = { 'helm_ls', 'serve' },
          }
        end,
      },
    },
  },
}
