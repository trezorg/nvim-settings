if not require("config").pde.yaml then
  return {}
end

local function disable_yamlls_for_helm()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("detach_yamlls_for_helm", {}),
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client ~= nil then
        if client.config.name == 'yamlls' and vim.bo.filetype == 'helm' then
          vim.lsp.buf_detach_client(bufnr, client.id)
          return
        end
        if client.config.name == 'helm_ls' then
          local clients = vim.lsp.get_clients()
          for _, loaded_client in pairs(clients) do
            if loaded_client.config.name == 'yamlls' then
              if vim.lsp.buf_is_attached(bufnr, loaded_client.id) then
                vim.lsp.buf_detach_client(bufnr, loaded_client.id)
                return
              end
            end
          end
        end
        if client.config.name == 'yamlls' then
          local clients = vim.lsp.get_clients()
          for _, loaded_client in pairs(clients) do
            if loaded_client.config.name == 'helm_ls' then
              if vim.lsp.buf_is_attached(bufnr, client.id) then
                vim.lsp.buf_detach_client(bufnr, client.id)
                return
              end
            end
          end
        end
      end
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "yaml" })
      end
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'yaml-language-server' })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              completion = true,
              single_file_support = true,
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] =
                "/*.k8s.yaml",
              },
            },
          },
        },
      },
      setup = {
        yamlls = function(_, _)
          local lspconfig = require 'lspconfig'
          lspconfig.yamlls.setup {
            cmd = { "yaml-language-server", "--stdio" },
            filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
          }
          -- disable_yamlls_for_helm()
        end,
      },
    },
  },
}
