if not require('config').pde.tilt then
  return {}
end

local function set_tiltfile_filetype()
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = {
      'Tiltfile',
      'tiltfile',
    },
    group = vim.api.nvim_create_augroup("tiltfile", {}),
    callback = function(ev)
      vim.opt_local.filetype = 'tiltfile'
    end
  })
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'starlark' })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'tilt' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tilt_ls = {},
      },
      setup = {
        tilt_ls = function(_, _)
          local configs = require 'lspconfig.configs'
          local parsers = require "nvim-treesitter.parsers"

          if not configs.tilt_ls then
            configs.tilt_ls = {
              default_config = {
                cmd = { 'tilt', 'lsp', 'start' },
                filetypes = { 'tiltfile' },
                root_dir = function(fname)
                  return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
                end,
                single_file_support = true,
              },
            }
          end

          set_tiltfile_filetype()
          -- https://neovim.io/doc/user/treesitter.html
          vim.treesitter.language.register('starlark', { 'tiltfile' })
        end,
      },
    },
  },
}
