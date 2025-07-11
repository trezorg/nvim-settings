return {
  "greggh/claude-code.nvim",
  event = 'VeryLazy',
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      command = "SHELL=/bin/bash claude", -- Command used to launch Claude Code
    })
  end
}
