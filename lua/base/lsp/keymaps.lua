local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  local lsp_definitions_new_tab = function()
    require('telescope.builtin').lsp_definitions({ jump_type = 'tab drop', reuse_win = true })
  end
  local lsp_references_new_tab = function()
    require('telescope.builtin').lsp_references({ jump_type = 'tab drop', reuse_win = true })
  end
  local lsp_implementations_new_tag = function()
    require('telescope.builtin').lsp_implementations({ jump_type = 'tab drop', reuse_win = true })
  end
  local lsp_type_definitions_new_tab = function()
    require('telescope.builtin').lsp_type_definitions({ jump_type = 'tab drop', reuse_win = true })
  end

  self:map('gd', 'Telescope lsp_definitions', { desc = 'Goto Definition' })
  self:map('gtd', lsp_definitions_new_tab, { desc = 'Goto Definition in new tab' })
  self:map('gr', 'Telescope lsp_references', { desc = 'References' })
  self:map('gtr', lsp_references_new_tab, { desc = 'References in new tab' })
  self:map('gI', 'Telescope lsp_implementations', { desc = 'Goto Implementation' })
  self:map('gtI', lsp_implementations_new_tag, { desc = 'Goto Implementation in new tab' })
  self:map('gb', 'Telescope lsp_type_definitions', { desc = 'Goto Type Definition' })
  self:map('gtb', lsp_type_definitions_new_tab, { desc = 'Goto Type Definition in new tab' })
  self:map('K', vim.lsp.buf.hover, { desc = 'Hover' })
  self:map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help', has = 'signatureHelp' })
  self:map('[d', M.diagnostic_goto(true), { desc = 'Next Diagnostic' })
  self:map(']d', M.diagnostic_goto(false), { desc = 'Prev Diagnostic' })
  self:map(']e', M.diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
  self:map('[e', M.diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
  self:map(']w', M.diagnostic_goto(true, 'WARNING'), { desc = 'Next Warning' })
  self:map('[w', M.diagnostic_goto(false, 'WARNING'), { desc = 'Prev Warning' })
  self:map('<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action', mode = { 'n', 'v' }, has = 'codeAction' })

  local format = require('base.lsp.format').format
  self:map('<leader>lf', format, { desc = 'Format Document', has = 'documentFormatting' })
  self:map('<leader>lf', format, { desc = 'Format Range', mode = 'v', has = 'documentRangeFormatting' })
  self:map('<leader>lr', vim.lsp.buf.rename, { expr = true, desc = 'Rename', has = 'rename' })

  self:map('<leader>ls', require('telescope.builtin').lsp_document_symbols, { desc = 'Document Symbols' })
  self:map('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })
  self:map('<leader>lw', require('base.lsp.utils').toggle_diagnostics, { desc = 'Toggle Inline Diagnostics' })
  self:map('<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
  self:map('<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  self:map('<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  self:map('<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  self:map('<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  self:map('<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. 'Provider']
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or 'n',
    lhs,
    type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
