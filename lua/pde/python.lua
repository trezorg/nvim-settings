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
    end,
  },
  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap-python',
      'mfussenegger/nvim-dap',
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
    config = function()
      require('venv-selector').setup {
        name = { 'venv', '.venv' },
        dap_enabled = true,
        poetry_path = '~/.cache/pypoetry/virtualenvs'
      }
    end,
  },
  {
    'brentyi/isort.vim',
    event = 'VeryLazy',
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed,
        { 'debugpy', 'black', 'isort', 'mypy', 'ruff', 'python-lsp-server', 'basedpyright' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {},
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                reportMissingImports = "error",
                stubPath = vim.fn.stdpath 'data' .. '/lazy/python-type-stubs/stubs',
                inlayHints = {
                  callArgumentNames = true
                }
              }
            }
          }
        },
        pyright = {
          mason = false,
          autostart = false,
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
        pylsp = {
          mason = false,
          autostart = false,
          settings = {
            pylsp = {
              plugins = {
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = false, executable = 'pylint' },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
              },
            },
          },
          flags = {
            debounce_text_changes = 200,
          },
        },
      },
      setup = {
        basedpyright = function(_, _)
          vim.g.python_host_prog = '/home/igor/.pyenv/shims/python'
          local lsp_utils = require 'base.lsp.utils'
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            if client.name == "basedpyright" then
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
        },
      })
    end,
  },
  {
    'microsoft/python-type-stubs',
    cond = false,
  },
  {
    'ellisonleao/dotenv.nvim',
    lazy = false,
    opts = {
      enable_on_load = true, -- will load your .env file upon loading a buffer
      verbose = false,       -- show error notification if .env file is not found and if .env is loaded
    },
  },
}
