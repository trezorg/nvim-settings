if not require("config").pde.docker then
  return {}
end

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'dockerfile-language-server', 'docker-compose-language-service' })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {}
      },
      setup = {
        docker_compose_language_service = function(_, _)
          local lspconfig = require 'lspconfig'
          local util = require 'lspconfig.util'
          lspconfig.docker_compose_language_service.setup {
            filetypes = { "yaml.docker-compose" },
            cmd = { "docker-compose-langserver", "--stdio" },
            single_file_support = true,
            root_dir = util.root_pattern(
              "docker-compose.yaml",
              "docker-compose.*.yaml",
              "docker-compose-*.yaml",
              "docker-compose.*.yml",
              "docker-compose-*.yml",
              "docker-compose.yml"
            )
          }
          vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
            pattern = {
              "docker-compose.yaml",
              "docker-compose.*.yaml",
              "docker-compose-*.yaml",
              "docker-compose.*.yml",
              "docker-compose-*.yml",
              "docker-compose.yml"
            },
            callback = function()
              local buf = vim.api.nvim_get_current_buf()
              vim.api.nvim_buf_set_option(buf, 'filetype', 'yaml.docker-compose')
            end,
          })
        end,
      },
    },
  },
}
