if not require('config').pde.protobuf then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "proto" })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'buf-language-server' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bufls = {
        },
      },
      setup = {
        bufls = function(_, _)
          local lspconfig = require 'lspconfig'
          local util = require 'lspconfig.util'

          lspconfig.bufls.setup {
            filetypes = { 'proto' },
            cmd = { 'bufls', 'serve' },
            root_dir = util.root_pattern("buf.work.yaml", ".git"),
          }
        end,
      },
    },
  }
}
