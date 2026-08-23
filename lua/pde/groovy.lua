if not require('config').pde.groovy then
  return {}
end

vim.filetype.add {
  filename = {
    Jenkinsfile = 'groovy',
  },
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'groovy' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'npm-groovy-lint' })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      linters_by_ft = {
        groovy = { 'npm-groovy-lint' },
      },
    },
    config = function(_, opts)
      local lint = require 'lint'
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      vim.schedule(function()
        lint.try_lint()
      end)
    end,
  },
}
