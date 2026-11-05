# Copilot Instructions

## What This Is

A personal Neovim (0.12+) configuration, originally forked from kickstart.nvim and split into modules.
Plugins are managed by lazy.nvim. See `README.md` for the full layout and keymaps.

## Architecture

- `init.lua` — sets the leader key and `vim.g.have_nerd_font`, then requires `config.options`, `config.keymaps`, `config.autocmds`, `config.lazy`. Nothing else belongs here.
- `lua/config/` — core editor setup with no plugin dependencies. `lazy.lua` bootstraps lazy.nvim and imports `lua/plugins/`.
- `lua/plugins/*.lua` — each file returns a **list** of lazy.nvim specs, grouped by domain (ui, editor, lsp, git, dotnet, ...).
- `snippets/<filetype>.lua` — LuaSnip snippets loaded with `luasnip.loaders.from_lua`.

## Conventions

- Configure plugins through the spec (`opts`, `config`, `keys`), never with a top-level `require('x').setup()` outside the spec.
- Plugin keymaps go in the spec's `keys` field so the plugin lazy-loads; global keymaps go in `lua/config/keymaps.lua`.
- Keymap descriptions use `[B]racket` notation for which-key (e.g. `'[S]earch [F]iles'`). Add new `<leader>` groups to the which-key `spec` in `lua/plugins/ui.lua`.
- Before adding a keymap, check for prefix conflicts (e.g. a `<leader>x` mapping makes every `<leader>x…` mapping wait for `timeoutlen`).
- Use Neovim 0.12 APIs: `vim.uv`, `vim.lsp.config`/`vim.lsp.enable`, `vim.keymap.set(..., { buf = n })`.
- New language servers go in the `servers` table in `lua/plugins/lsp.lua`; extra Mason tools in `tools`.

## Code Style

Lua is formatted with StyLua (`.stylua.toml`: 160 columns, 2 spaces, single quotes, no call parentheses). CI runs `stylua --check .`.
