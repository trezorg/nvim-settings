if not require('config').pde.go then
  return {}
end

local function set_go_test_keymaps(bufnr)
  local map = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
  end

  local run_nearest = function(args, fallback)
    vim.cmd 'write'
    args = args or {}

    local neotest = require 'neotest'
    local nearest = neotest.run.get_tree_from_args()
    if nearest then
      neotest.run.run(vim.tbl_extend('force', { nearest:data().id }, args))
    else
      fallback()
    end
  end

  map('<leader>tn', function()
    run_nearest({ extra_args = { '-race' } }, function()
      require('go.gotest').test_func('-b', '-race')
    end)
  end, 'Nearest (fallback GoTest) with race')
  map('<leader>tf', function()
    vim.cmd 'write'
    require('go.gotest').test_file('-b', '-race')
  end, 'File (GoTestFile) with race')
  map('<leader>tN', function()
    run_nearest({ strategy = 'dap' }, function()
      vim.cmd 'GoDebug -n'
    end)
  end, 'Debug nearest (fallback GoDebug)')
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(args)
    set_go_test_keymaps(args.buf)
  end,
})

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
      vim.list_extend(opts.ensure_installed, {
        'delve',
        'gotests',
        'golangci-lint',
        'gofumpt',
        'goimports',
        'golangci-lint-langserver',
        'impl',
        'gomodifytags',
        'iferr',
        'gotestsum',
      })
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
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules', '-.nvim' },
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
            map('n', '<leader>la', function()
              vim.lsp.codelens.run()
            end, 'Code Lens')
            map('n', '<leader>ly', '<cmd>GoModTidy<cr>', 'Go Mod Tidy')
            map('n', '<leader>lc', '<cmd>GoCoverage<Cr>', 'Go Test Coverage')
            map('n', '<leader>lt', '<cmd>GoTest<Cr>', 'Go Test')
            map('n', '<leader>lR', '<cmd>GoRun<Cr>', 'Go Run')
            map('n', '<leader>dT', "<cmd>lua require('dap-go').debug_test()<cr>", 'Go Debug Test')
            set_go_test_keymaps(bufnr)
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
      'nvim-contrib/nvim-ginkgo',
    },
    opts = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      opts.adapters = opts.adapters or {}

      local neotest_go = require 'neotest-go' {
        recursive_run = true,
        experimental = {
          test_table = true,
        },
        args = { '-race', '-count=1', '-timeout=60s' },
      }

      neotest_go.root = require('neotest.lib').files.match_root_pattern('go.work', 'go.mod', 'go.sum')

      table.insert(opts.adapters, 1, neotest_go)
      -- table.insert(opts.adapters, require 'nvim-ginkgo')
    end,
  },
}
