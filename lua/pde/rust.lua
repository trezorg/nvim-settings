if not require('config').pde.rust then
  return {}
end

local function get_codelldb()
  local path = vim.fn.expand '$MASON/packages/codelldb'
  -- local mr = require 'mason-registry'
  -- local codelldb = mr.get_package('codelldb')
  local extension_path = path .. '/extension/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
  return codelldb_path, liblldb_path
end

local function setup_crates_keymaps(bufnr)
  local wk = require 'which-key'
  local keys = { mode = { 'n', 'v' }, { '<leader>lc', group = '+Crates' } }
  wk.add(keys)

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
  end

  map('n', '<leader>lcy', "<cmd>lua require'crates'.open_repository()<cr>", 'Open Repository')
  map('n', '<leader>lcp', "<cmd>lua require'crates'.show_popup()<cr>", 'Show Popup')
  map('n', '<leader>lci', "<cmd>lua require'crates'.show_crate_popup()<cr>", 'Show Info')
  map('n', '<leader>lcf', "<cmd>lua require'crates'.show_features_popup()<cr>", 'Show Features')
  map('n', '<leader>lcd', "<cmd>lua require'crates'.show_dependencies_popup()<cr>", 'Show Dependencies')
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'rust' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'codelldb' })
    end,
  },
  { 'rust-lang/rust.vim' },
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      null_ls = {
        enabled = true,
        name = 'crates.nvim',
      },
      popup = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('crates').setup(opts)
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = { 'Cargo.toml' },
        callback = function(event)
          setup_crates_keymaps(event.buf)
        end,
      })

      if vim.fn.expand '%:t' == 'Cargo.toml' then
        setup_crates_keymaps(0)
      end
    end,
  },
  {
    'mfussenegger/nvim-dap',
    opts = {
      setup = {
        codelldb = function()
          local codelldb_path, _ = get_codelldb()
          local dap = require 'dap'
          dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
              command = codelldb_path,
              args = { '--port', '${port}' },

              -- On windows you may have to uncomment this:
              -- detached = false,
            },
          }
          dap.configurations.cpp = {
            {
              name = 'Launch file',
              type = 'codelldb',
              request = 'launch',
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
            },
          }

          dap.configurations.c = dap.configurations.cpp
          dap.configurations.rust = dap.configurations.cpp
        end,
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { border = 'solid' },
        },
        server = {
          capabilities = require('base.lsp.utils').capabilities(),
          default_settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = {
                command = 'clippy',
                extraArgs = {
                  '--all-targets',
                  '--all-features',
                  '--locked',
                  '--',
                  '-D',
                  'warnings',
                  '-D',
                  'clippy::all',
                  '-D',
                  'clippy::pedantic',
                  '-D',
                  'clippy::nursery',
                  '-D',
                  'clippy::cargo',
                },
              },
            },
          },
          on_attach = function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end

            local run_codelens = function()
              vim.lsp.codelens.run()
            end

            -- map({ 'n', 'v' }, '<leader>lA', function()
            --   vim.cmd.RustLsp 'codeAction'
            -- end, 'Code Action')

            map({ 'n', 'v' }, '<leader>lA', vim.lsp.buf.code_action, 'Code Action')
            map('n', '<leader>la', run_codelens, 'Code Lens')
            map('n', '<leader>le', '<cmd>RustLsp runnables<cr>', 'Runnables')
            map('n', '<leader>ll', run_codelens, 'Code Lens')
            map('n', '<leader>lt', '<cmd>Cargo test<cr>', 'Cargo test')
            map('n', '<leader>lR', '<cmd>Cargo run<cr>', 'Cargo run')
            map('n', '<leader>tn', function()
              vim.cmd 'write'
              local neotest = require 'neotest'
              local nearest = neotest.run.get_tree_from_args()
              if nearest then
                neotest.run.run()
              else
                neotest.run.run(vim.fn.expand '%')
              end
            end, 'Nearest (fallback file)')
          end,
        },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        pattern = { '*.rs' },
        callback = function()
          vim.lsp.codelens.enable(true)
        end,
      })
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'rouge8/neotest-rust',
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}

      local neotest_rust = require 'neotest-rust' {
        -- curl -LsSf https://get.nexte.st/latest/linux | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin
        args = { '--no-capture' },
      }

      neotest_rust.root = require('neotest.lib').files.match_root_pattern 'Cargo.toml'

      table.insert(opts.adapters, 1, neotest_rust)
    end,
  },
}
