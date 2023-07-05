if not require('config').pde.terraform then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'hcl', 'terraform' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'terraform-ls', 'tflint' })
    end,
  },
  { 'hashivim/vim-terraform', event = 'VeryLazy' },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        terraformls = {},
      },
      setup = {
        terraformls = function(_, _)
          -- vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
          --   pattern = { '*.tf', '*.tfvars' },
          --   callback = vim.lsp.buf.format,
          -- })
          local lsp_utils = require 'base.lsp.utils'
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            if client.name == 'terraformls' then
              map('n', '<leader>lti', ':!terraform init<CR>', 'terraform init')
              map('n', '<leader>ltv', ':!terraform validate<CR>', 'terraform validate')
              map('n', '<leader>ltp', ':!terraform plan<CR>', 'terraform plan')
              map('n', '<leader>lta', ':!terraform apply -auto-approve<CR>', 'terraform apply')
            end
          end)
        end,
      },
    },
  },
}
