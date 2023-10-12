if not require('config').pde.python then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'python' })
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = {
        nls.builtins.formatting.black,
        nls.builtins.formatting.isort,
        nls.builtins.diagnostics.ruff,
        nls.builtins.diagnostics.mypy,
      }
      opts.on_attach = function(client, bufnr)
        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end

      -- table.insert(opts.sources, nls.builtins.formatting.black)
      -- table.insert(opts.sources, nls.builtins.formatting.isort)
      -- table.insert(opts.sources, nls.builtins.diagnostics.ruff)
    end,
  },
  {
    'trezorg/poet-v',
    lazy = false,
    -- event = 'VeryLazy',
    init = function()
      vim.g.poetv_auto_activate = 1
      vim.g.poetv_set_environment = 1
      vim.g.poetv_executables = { 'pipenv', 'poetry' }
    end,
  },
  {
    'brentyi/isort.vim',
    event = 'VeryLazy',
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'debugpy', 'black', 'ruff', 'isort', "mypy" })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly', -- "openFilesOnly" or "openFilesOnly"
                stubPath = vim.fn.stdpath 'data' .. '/lazy/python-type-stubs/stubs',
              },
            },
          },
        },
      },
      setup = {
        pyright = function(_, _)
          local lsp_utils = require 'base.lsp.utils'
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            if client.name == "pyright" then
              map("n", "<leader>lo", "<cmd>PyrightOrganizeImports<cr>", "Organize Imports")
              map("n", "<leader>lC", function() require("dap-python").test_class() end, "Debug Class")
              map("n", "<leader>lM", function() require("dap-python").test_method() end, "Debug Method")
              map("v", "<leader>lE", function() require("dap-python").debug_selection() end, "Debug Selection")
            end
          end)
        end,
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      config = function()
        require('dap-python').setup() -- Use default python
      end,
    },
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require 'neotest-python' {
          dap = { justMyCode = false },
          runner = 'pytest',
          -- is_test_file = function(file_path)
          --     if string.find(file_path, 'tests') == nil then
          --         return false
          --     else
          --         return true
          --     end
          -- end,
        },
      })
    end,
  },
  {
    'microsoft/python-type-stubs',
    cond = false,
  },
  {
    "ellisonleao/dotenv.nvim",
    lazy = false,
    opts = {
      enable_on_load = true, -- will load your .env file upon loading a buffer
      verbose = false,       -- show error notification if .env file is not found and if .env is loaded
    },
  },
}
