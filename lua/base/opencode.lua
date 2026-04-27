return {
  -- https://github.com/sudo-tee/opencode.nvim?tab=readme-ov-file#-quick-chat
  'sudo-tee/opencode.nvim',
  event = 'VeryLazy',
  config = function()
    require('opencode').setup {
      preferred_picker = 'telescope',
      preferred_completion = 'blink',
      keymap_prefix = '<leader>o',
      -- keymap = {
      --   editor = {
      --     ['<leader>og'] = { 'toggle' },                          -- Open opencode. Close if opened
      --     ['<leader>oi'] = { 'open_input' },                      -- Opens and focuses on input window on insert mode
      --     ['<leader>oI'] = { 'open_input_new_session' }, -- Opens and focuses on input window on insert mode. Creates a new session
      --     ['<leader>oo'] = { 'open_output' }, -- Opens and focuses on output window
      --     ['<leader>ot'] = { 'toggle_focus' }, -- Toggle focus between opencode and last window
      --     ['<leader>oT'] = { 'timeline' }, -- Display timeline picker to navigate/undo/redo/fork messages
      --     ['<leader>oq'] = { 'close' }, -- Close UI windows
      --     ['<leader>os'] = { 'select_session' }, -- Select and load a opencode session
      --     ['<leader>oR'] = { 'rename_session' }, -- Rename current session
      --     ['<leader>op'] = { 'configure_provider' }, -- Quick provider and model switch from predefined list
      --     ['<leader>oV'] = { 'configure_variant' }, -- Switch model variant for the current model
      --     ['<leader>oy'] = { 'add_visual_selection', mode = { 'v' } },
      --     ['<leader>oz'] = { 'toggle_zoom' }, -- Zoom in/out on the Opencode windows
      --     ['<leader>ov'] = { 'paste_image' }, -- Paste image from clipboard into current session
      --     ['<leader>od'] = { 'diff_open' }, -- Opens a diff tab of a modified file since the last opencode prompt
      --     ['<leader>o]'] = { 'diff_next' }, -- Navigate to next file diff
      --     ['<leader>o['] = { 'diff_prev' }, -- Navigate to previous file diff
      --     ['<leader>oc'] = { 'diff_close' }, -- Close diff view tab and return to normal editing
      --     ['<leader>ora'] = { 'diff_revert_all_last_prompt' }, -- Revert all file changes since the last opencode prompt
      --     ['<leader>ort'] = { 'diff_revert_this_last_prompt' }, -- Revert current file changes since the last opencode prompt
      --     ['<leader>orA'] = { 'diff_revert_all' }, -- Revert all file changes since the last opencode session
      --     ['<leader>orT'] = { 'diff_revert_this' }, -- Revert current file changes since the last opencode session
      --     ['<leader>orr'] = { 'diff_restore_snapshot_file' }, -- Restore a file to a restore point
      --     ['<leader>orR'] = { 'diff_restore_snapshot_all' }, -- Restore all files to a restore point
      --     ['<leader>ox'] = { 'swap_position' }, -- Swap Opencode pane left/right
      --     ['<leader>ott'] = { 'toggle_tool_output' }, -- Toggle tools output (diffs, cmd output, etc.)
      --     ['<leader>otr'] = { 'toggle_reasoning_output' }, -- Toggle reasoning output (thinking steps)
      --     ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
      --   },
      -- },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-mini/mini.nvim',
      },
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
        completions = { lsp = { enabled = true } },
      },
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    },
    -- Optional, for file mentions and commands completion, pick only one
    {
      'saghen/blink.cmp',
      dependencies = { 'saghen/blink.lib' },
    },
    -- 'hrsh7th/nvim-cmp',

    -- Optional, for file mentions picker, pick only one
    'folke/snacks.nvim',
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim_mini/mini.nvim',
  },
}
