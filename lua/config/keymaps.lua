local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', 'g,', 'g,zvzz')
keymap('n', 'g;', 'g;zvzz')

-- Scrolling
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')

-- Paste
keymap('n', ']p', 'o<Esc>p', { desc = 'Paste below' })
keymap('n', ']P', 'O<Esc>p', { desc = 'Paste above' })

-- Better escape using jk in insert and terminal mode
keymap('i', 'jk', '<ESC>')
keymap('t', 'jk', '<C-\\><C-n>')
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h')
keymap('t', '<C-j>', '<C-\\><C-n><C-w>j')
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k')
keymap('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Add undo break-points
keymap('i', ',', ',<c-g>u')
keymap('i', '.', '.<c-g>u')
keymap('i', ';', ';<c-g>u')

-- Better indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Paste over currently selected text without yanking it
keymap('v', 'p', '"_dp', { silent = true, desc = 'Paste in visual mode' })
keymap('v', 'P', '"_dP', { silent = true, desc = 'Paste in visual mode' })
-- Search in visual mode
keymap('v', 'g/', 'y/<C-R>"<CR>', { silent = true, desc = 'Search selected in visual mode' })
-- Paste over word without yanking it
keymap('n', 'S', '"_diwP', { silent = true, desc = 'Delete word and paste' })
-- Paste over string without yanking it
keymap('n', 'ss', '"_ddP', { silent = true, desc = 'Delete word and paste' })

-- Insert blank line
keymap('n', ']<Space>', 'o<Esc>')
keymap('n', '[<Space>', 'O<Esc>')

-- Auto indent
keymap('n', 'i', function()
  if #vim.fn.getline '.' == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

function CdAndNotify(command)
  local path = vim.fn.expand('%:h')
  vim.cmd(command .. " " .. path)
  vim.notify(path)
end

keymap({ 'n', 'i' }, '<C-Tab>', '<cmd>tabnext<CR>')
keymap({ 'n', 'i' }, '<C-S-Tab>', '<cmd>tabprevious<CR>')
keymap({ 'n', 'i' }, '<C-Insert>', '<cmd>tabnew<CR>')
keymap({ 'n', 'i' }, '<C-Delete>', '<cmd>tabclose<CR>')

keymap('n', '<leader>ss', '<cmd>mksession!<CR>', { silent = true, desc = 'Save session' })
keymap('n', '<leader>sl', '<cmd>source<CR>', { silent = true, desc = 'Load session' })
keymap('n', '<leader>cd', '<cmd>:lua CdAndNotify("lcd")<CR>', { silent = true, desc = 'Cnange directory for window' })
keymap('n', '<leader>ctd', '<cmd>:lua CdAndNotify("tcd")<CR>', { silent = true, desc = 'Cnange directory for tab' })

keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
