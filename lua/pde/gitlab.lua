if not require('config').pde.gitlab then
  return {}
end

vim.filetype.add {
  filename = {
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
    ['.gitlab-ci.yaml'] = 'yaml.gitlab',
  },
}

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('gitlab_yaml_filetype', { clear = true }),
  pattern = { '*.yaml', '*.yml' },
  callback = function(args)
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ''
    if vim.startswith(vim.trim(first_line), '# code: language=gitlab') then
      vim.bo[args.buf].filetype = 'yaml.gitlab'
    end
  end,
})

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'gitlab-ci-ls' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gitlab_ci_ls = {},
      },
    },
  },
}
