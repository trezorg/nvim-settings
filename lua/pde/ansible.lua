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
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        pattern = { 'hosts.yaml', 'hosts', 'hosts.yml' },
        callback = function()
          -- if vim.fn.search('{{.\\+}}', 'nw') ~= 0 then
          local buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_set_option(buf, 'filetype', 'yaml.ansible')
          -- end
        end,
      })
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        pattern = { '*.yaml', '*.yml' },
        callback = function()
          if vim.fn.match(vim.fn.trim(vim.fn.getline(1)), '# code: language=ansible') >= 0 then
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_option(buf, 'filetype', 'yaml.ansible')
          end
        end,
      })
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
