if not require('config').pde.nginx then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'nginx' })
    end,
  },
  -- {
  --   'williamboman/mason.nvim',
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, { 'nginx-language-server' })
  --   end,
  -- },
  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       nginx_language_server = {},
  --     },
  --   },
  -- },
}
