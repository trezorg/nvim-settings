if not require("config").pde.gitlab then
  return {}
end

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'gitlab-ci-ls' })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gitlab_ci_ls = {},
      },
      setup = {
        gitlab_ci_ls = function(_, _)
          vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = "*.gitlab-ci*.{yml,yaml}",
            callback = function()
              vim.bo.filetype = "yaml.gitlab"
            end,
          })
        end,
      },
    },
  },
}
