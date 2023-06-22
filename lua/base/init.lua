return {
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-rhubarb' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-abolish' },

  { 'nvim-lua/plenary.nvim' },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit' },
    dependencies = {
      'tpope/vim-rhubarb',
    },
    -- stylua: ignore
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      defaults = {
        ['<leader>g'] = { name = '+Git' },
      },
    },
  },
}
