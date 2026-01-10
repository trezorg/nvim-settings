local function augroup(name)
  return vim.api.nvim_create_augroup('nde_' .. name, { clear = true })
end

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup 'highlight_yank',
  pattern = '*',
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- windows to close
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'OverseerForm',
    'OverseerList',
    'checkhealth',
    'floggraph',
    'fugitive',
    'git',
    'help',
    'lspinfo',
    'man',
    'neotest-output',
    'neotest-summary',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'toggleterm',
    'tsplayground',
    'vim',
    'neoai-input',
    'neoai-output',
    'notify',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Open neo-tree on startup (no args or first arg is a directory)
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup 'neotree',
  callback = function()
    local neotree_opts = {
      toggle = false,
      reveal = false,
      reveal_force_cwd = false,
      action = 'focus',
      source = 'filesystem',
      position = 'left',
    }
    local argc = vim.fn.argc()
    if argc == 0 then
      vim.defer_fn(function()
        require('neo-tree.command').execute(neotree_opts)
      end, 0)
    elseif argc > 0 then
      local first_arg = vim.fn.argv(0)
      if vim.fn.isdirectory(first_arg) == 1 then
        vim.defer_fn(function()
          local opts = vim.tbl_extend('force', neotree_opts, { dir = first_arg })
          require('neo-tree.command').execute(opts)
        end, 0)
      end
    end
  end,
  once = true,
})

-- new tab change directory
-- vim.api.nvim_create_autocmd('TabNewEntered', {
--   pattern = '*',
--   callback = function()
--     local path = vim.fn.expand '%:p'
--     if vim.fn.filereadable(path) then
--       local dirname = vim.fn.fnamemodify(path, ':h')
--       local ext = vim.fn.fnamemodify(path, ':e')
--       vim.cmd('tcd ' .. dirname)
--       vim.notify(dirname)
--     end
--   end,
-- })
