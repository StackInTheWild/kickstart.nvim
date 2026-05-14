# Copilot Instructions for kickstart.nvim

## What This Is

A personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It extends the single-file kickstart base (`init.lua`) with custom plugins, keymaps, and settings.

## Architecture

- **`init.lua`** — The main configuration file. Contains core settings, keymaps, plugin manager bootstrap (lazy.nvim), and all base plugin specs in a single `require('lazy').setup({...})` call. Also has post-setup configuration at the bottom (Oil, treesitter-context, jest, diffview, fugitive keymaps, etc.).
- **`lua/kickstart/`** — Optional upstream kickstart plugin modules (e.g., `autopairs`, `neo-tree`, `gitsigns`, `debug`, `lint`, `indent_line`). Loaded via `require 'kickstart.plugins.X'` inside the lazy.setup call.
- **`lua/custom/plugins/`** — User-added plugin specs, auto-imported via `{ import = 'custom.plugins' }`. Each file returns a lazy.nvim plugin spec table. This is the primary place to add new plugins.
- **`lua/custom/remap.lua`** — Custom keymaps (loaded via `require 'custom/remap'` at end of init.lua).
- **`lua/custom/set.lua`** — Custom vim options like colorcolumn, font, termguicolors.
- **`lua/custom/snippets.lua`** — LuaSnip snippet loader, required from `lua/custom/plugins/init.lua`.
- **`lua/snippets/`** — Language-specific snippet definitions (e.g., `typescriptreact.lua`).

## Key Conventions

### Plugin Management
- Uses **lazy.nvim** for plugin management. Run `:Lazy` to check status, `:Lazy update` to update.
- LSP servers are managed via **Mason**. Run `:Mason` to manage installed servers.
- New plugins go in `lua/custom/plugins/` as individual files returning a lazy.nvim spec.

### Code Style
- Leader key is `<Space>`.
- Lua code is formatted with **StyLua** (CI enforces this on PRs).
- StyLua config: 160 column width, 2-space indentation, single quotes preferred, Unix line endings (see `.stylua.toml`).
- Keymap descriptions use `[B]racket` notation for which-key discoverability (e.g., `'[S]earch [F]iles'`).

### Formatting
Run StyLua to check/format Lua files:
```sh
stylua --check .
stylua .
```

### Editor Settings
- Default shiftwidth is 4 with expandtab (spaces, not tabs).
- Format-on-save is enabled via conform.nvim (uses StyLua for Lua, prettierd/prettier for JS/TS/TSX).
- Nerd Font support is enabled (`vim.g.have_nerd_font = true`).
- Colorscheme is rose-pine with tokyonight available as a transparent alternative.

### Notable Custom Additions
- **Oil.nvim** for file browsing (`-` to open).
- **Harpoon** for file navigation.
- **Copilot** for AI completions.
- **nvim-jest** for running Jest tests (`jest_cmd = 'npx jest'`).
- **Fugitive** and **Diffview** for Git workflows.
- **Treesitter-context** shows sticky function/class headers.
- Completion uses `<Enter>` to confirm, `<C-j>`/`<C-k>` to navigate, `<C-l>`/`<C-h>` for snippet jumps.
