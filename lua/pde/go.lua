if not require('config').pde.go then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'go', 'gomod', 'gowork', 'gosum' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(
        opts.ensure_installed,
        {
          'delve',
          'gotests',
          'golangci-lint',
          'gofumpt',
          'goimports',
          'golangci-lint-langserver',
          'impl',
          'gomodifytags',
          'iferr',
          'gotestsum'
        }
      )
    end,
  },
  {
    'ray-x/go.nvim',
    version = false,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp_codelens = true,
    },
    config = function(_, opts)
      require('go').setup(opts)
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedvariable = true,
                unusedresult = true,
                unusedparams = true,
                unusedwrite = true,
                fieldalignment = true,
                nilness = true,
                useany = true,
                unsafeptr = true,
                unreachable = true,
                tests = true,
              },
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
              semanticTokens = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              completeFunctionCalls = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules", "-.nvim" },
            },
          },
        },
        golangci_lint_ls = {},
      },
      setup = {
        gopls = function(_, _)
          local lsp_utils = require 'base.lsp.utils'
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            --
            if client.name == "gopls" then
              map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens")
              map("n", "<leader>ly", "<cmd>GoModTidy<cr>", "Go Mod Tidy")
              map("n", "<leader>lc", "<cmd>GoCoverage<Cr>", "Go Test Coverage")
              map("n", "<leader>lt", "<cmd>GoTest<Cr>", "Go Test")
              map("n", "<leader>lR", "<cmd>GoRun<Cr>", "Go Run")
              map("n", "<leader>dT", "<cmd>lua require('dap-go').debug_test()<cr>", "Go Debug Test")
              map("n", "<leader>tn", "<cmd>w|lua require('neotest').run.run({extra_args = {'-race'}})<cr>",
                "Nearest with race")
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
        end,
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'leoluz/nvim-dap-go', opts = {} },
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-go',
    },
    opts = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      vim.list_extend(opts.adapters, {
        require("neotest-go")({
          recursive_run = true,
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" }
        })
      })
    end,
  },
}
