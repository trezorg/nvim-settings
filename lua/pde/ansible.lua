if not require('config').pde.ansible then
  return {}
end

vim.filetype.add {
  filename = {
    hosts = 'yaml.ansible',
    ['hosts.yml'] = 'yaml.ansible',
    ['hosts.yaml'] = 'yaml.ansible',
  },
}

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('ansible_yaml_filetype', { clear = true }),
  pattern = { '*.yaml', '*.yml' },
  callback = function(args)
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ''
    if vim.startswith(vim.trim(first_line), '# code: language=ansible') then
      vim.bo[args.buf].filetype = 'yaml.ansible'
    end
  end,
})

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
