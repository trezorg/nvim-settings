if not require('config').pde.markdown then
  return {}
end

local HOME = os.getenv 'HOME'
return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'markdown', 'markdown_inline' })
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    event = 'VeryLazy',
    lazy = false,
    config = function()
      vim.fn['mkdp#util#install']()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { silent = true, desc = 'MarkdownPreview' })
      vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', { silent = true, desc = 'MarkdownPreviewStop' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'marksman', 'markdownlint-cli2' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  -- {
  --   'nvimtools/none-ls.nvim',
  --   opts = function(_, opts)
  --     local nls = require 'null-ls'
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.diagnostics.markdownlint_cli2.with {
  --         -- args = { '$FILENAME' },
  --         -- args = { '--stdout', '**/*.md' },
  --       }
  --     )
  --     table.insert(opts.sources, nls.builtins.formatting.prettier.with { filetypes = { 'markdown', 'markdown.mdx' } })
  --   end,
  -- },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
      },
      linters = {
        ['markdownlint-cli2'] = {
          args = { '--config', vim.fn.expand '$HOME/.markdownlint-cli2.yaml', '--' },
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters = {
        ['markdownlint-cli2'] = {
          args = { '--config', vim.fn.expand '$HOME/.markdownlint-cli2.yaml', '--fix', '$FILENAME' },
        },
      },
    },
  },
}
