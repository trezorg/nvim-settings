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
  {
    'pearofducks/ansible-vim',
    event = 'VeryLazy',
    init = function()
      vim.g.ansible_attribute_highlight = 'ob'
      vim.g.ansible_name_highlight = 'd'
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
}
