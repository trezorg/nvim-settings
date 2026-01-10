# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This neovim configuration uses **lazy.nvim** for plugin management with a modular architecture split into two plugin collections:

- **`lua/base/`** - Editor-agnostic functionality (LSP, DAP, treesitter, completion, UI themes, file browsing, git)
- **`lua/pde/`** - Per-language modules that extend base functionality for specific languages (Python, Go, TypeScript, Rust, etc.)

Entry point is `init.lua` which loads core config modules (`lua/config/`) in order: options, lazy, autocmds, keymaps.

## Feature Toggle System

Language modules are conditionally enabled via `lua/config/init.lua`. Each PDE module checks `require('config').pde.<language>` before loading:

```lua
if not require('config').pde.python then
  return {}
end
```

Toggle languages on/off by editing the `pde` table in `lua/config/init.lua`. Disabled modules return an empty table.

## Adding New Language Support

Create a new file in `lua/pde/<lang>.lua` following this pattern:

```lua
if not require('config').pde.<lang> then
  return {}
end

return {
  -- Extend treesitter parsers
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { '<lang>' })
    end,
  },
  -- Add Mason tools
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { '<lsp-server>', '<formatter>' })
    end,
  },
  -- Configure null-ls formatting/diagnostics
  {
    'nvimtools/none-ls.nvim',
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = {
        nls.builtins.formatting.<formatter>,
      }
    end,
  },
}
```

## Common Patterns

**Extending plugin opts**: Use the `opts` function to modify existing plugin configuration:
```lua
opts = function(_, opts)
  vim.list_extend(opts.ensure_installed, { 'parser' })
  -- or
  opts.settings = vim.tbl_deep_extend('force', opts.settings or {}, { ... })
end
```

**LSP server configuration**: Servers are configured via `base.lsp.servers.setup()`. Add language-specific LSP config in PDE modules by extending the `opts.servers` table.

**Formatting on save**: null-ls sources typically attach a BufWritePre autocmd for formatting (see `lua/pde/python.lua` for pattern).

## Key Settings

- Leader key: `Space` (SPC)
- Local leader: `,`
- Colorscheme: `darcula` (alternatives available: vscode, onedark, tokyonight, catppuccin)
- Auto-save: Enabled with 5 second debounce
- Spell check: English + Russian
- No swap files (uses undofile)
