if not require('config').pde.rust then
  return {}
end

local function get_codelldb()
  local path = vim.fn.expand "$MASON/packages/codelldb"
  -- local mr = require 'mason-registry'
  -- local codelldb = mr.get_package('codelldb')
  local extension_path = path .. '/extension/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
  return codelldb_path, liblldb_path
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
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'simrat39/rust-tools.nvim', 'rust-lang/rust.vim' },
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = 'cargo clippy',
                extraArgs = { '--no-deps' },
              },
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(_, opts)
          local codelldb_path, liblldb_path = get_codelldb()
          local lsp_utils = require 'base.lsp.utils'
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            if client.name == "rust_analyzer" then
              map("n", "<leader>le", "<cmd>RustRunnables<cr>", "Runnables")
              map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens")
              map("n", "<leader>lt", "<cmd>Cargo test<cr>", "Cargo test")
              map("n", "<leader>lR", "<cmd>Cargo run<cr>", "Cargo run")
            end
          end)

          vim.api.nvim_create_autocmd({ 'BufEnter' }, {
            pattern = { 'Cargo.toml' },
            callback = function(event)
              local bufnr = event.buf

              -- Register keymappings
              local wk = require 'which-key'
              local keys = { mode = { 'n', 'v' }, { '<leader>lc', group = '+Crates' } }
              wk.add(keys)

              local map = function(mode, lhs, rhs, desc)
                if desc then
                  desc = desc
                end
                vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
              end
              map('n', '<leader>lcy', "<cmd>lua require'crates'.open_repository()<cr>", 'Open Repository')
              map('n', '<leader>lcp', "<cmd>lua require'crates'.show_popup()<cr>", 'Show Popup')
              map('n', '<leader>lci', "<cmd>lua require'crates'.show_crate_popup()<cr>", 'Show Info')
              map('n', '<leader>lcf', "<cmd>lua require'crates'.show_features_popup()<cr>", 'Show Features')
              map('n', '<leader>lcd', "<cmd>lua require'crates'.show_dependencies_popup()<cr>", 'Show Dependencies')
            end,
          })

          require('rust-tools').setup {
            tools = {
              hover_actions = { border = 'solid' },
              on_initialized = function()
                vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                  pattern = { '*.rs' },
                  callback = function()
                    vim.lsp.codelens.refresh()
                  end,
                })
              end,
            },
            server = opts,
            dap = {
              adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
            },
          }
          return true
        end,
      },
    },
  },
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
    'nvim-neotest/neotest',
    dependencies = {
      'rouge8/neotest-rust',
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        -- curl -LsSf https://get.nexte.st/latest/linux | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin
        require('neotest-rust') {
          args = { "--no-capture" }
        },
      })
    end,
  },
}
