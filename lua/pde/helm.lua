if not require('config').pde.helm then
  return {}
end

local function set_yaml_for_helm_files()
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWrite' }, {
    pattern = {
      '*/templates/*.yaml',
      '*/templates/*.yml',
      '*/templates/*.tpl',
      '*.gotmpl',
      'helmfile*.yaml',
    },
    group = vim.api.nvim_create_augroup("set_filetype_of_helm", {}),
    callback = function(ev)
      vim.opt_local.filetype = 'helm'
      vim.cmd([[ LspRestart ]])
      vim.diagnostic.reset()
      local client = vim.lsp.get_clients({ bufnr = ev.buf, name = "yamlls" })[1]
      if client then
        local ns = vim.lsp.diagnostic.get_namespace(client.id)
        vim.diagnostic.enable(false, { ns_id = ns })
      end
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
  {
    'towolf/vim-helm',
    ft = 'helm'
  },
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
                filetypes = { "helm", "helmfile" },
                root_dir = function(fname)
                  return util.root_pattern 'Chart.yaml' (fname)
                end,
              },
            }
          end

          -- set_yaml_for_helm_files()

          lspconfig.helm_ls.setup {
            filetypes = { "helm", "helmfile" },
            cmd = { 'helm_ls', 'serve' },
            root_dir = function(fname)
              return util.root_pattern 'Chart.yaml' (fname)
            end,
          }
        end,
      },
    },
  },
}
