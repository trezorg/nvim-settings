if not require('config').pde.ansible then
  return {}
end

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'yamllint', 'ansible-lint', 'ansible-language-server' })
    end,
  },
  { 'pearofducks/ansible-vim', event = 'VeryLazy' },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
}
