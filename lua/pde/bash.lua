if not require('config').pde.bash then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'bash' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'bash-language-server' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
}
