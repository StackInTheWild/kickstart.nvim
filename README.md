# nvim config

Personal Neovim configuration, originally forked from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and since split into modules.
Tuned for **C# / ASP.NET Core** and **TypeScript / React** work.

## Requirements

- Neovim **0.12+**
- `git`, `make`, `unzip`, a C compiler, [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- `node` / `npm` (TypeScript & CSS language servers, prettier, Copilot)
- .NET SDK (`dotnet`) for easy-dotnet / Roslyn
- A [Nerd Font](https://www.nerdfonts.com/) (set `vim.g.have_nerd_font = false` in `init.lua` if you don't have one)
- Optional: `fd`, [`lazygit`](https://github.com/jesseduffield/lazygit), `tmux` + `tmux-sessionizer`,
  [`difftastic`](https://github.com/Wilfred/difftastic)

Language servers, formatters and `netcoredbg` are installed automatically by Mason.
Run `:checkhealth config` to see what's missing.

## Install

```sh
# Linux / macOS
git clone https://github.com/StackInTheWild/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

```powershell
# Windows
git clone https://github.com/StackInTheWild/kickstart.nvim.git "$env:LOCALAPPDATA\nvim"
```

Start `nvim`; lazy.nvim installs everything on first launch. `lazy-lock.json` is committed so
plugin versions are reproducible — use `:Lazy restore` to match it, `:Lazy update` to bump it.

## Layout

```
init.lua                 entry point: leader key, then loads lua/config/*
lua/config/
  options.lua            editor options + diagnostics
  keymaps.lua            global keymaps (no plugin dependencies)
  autocmds.lua           autocommands
  lazy.lua               lazy.nvim bootstrap; imports lua/plugins/
  health.lua             :checkhealth config
lua/plugins/             one file per domain, each returns a list of lazy.nvim specs
  ui.lua                 colorschemes, which-key, mini, barbar, noice, ...
  editor.lua             oil, neo-tree, harpoon, trouble, autopairs, ...
  telescope.lua          fuzzy finder + search keymaps
  lsp.lua                mason + language servers (vtsls, cssls, lua_ls)
  completion.lua         blink.cmp + LuaSnip
  formatting.lua         conform.nvim (format on save)
  treesitter.lua         treesitter, context, autotag
  git.lua                gitsigns, fugitive, diffview, lazygit, blame, ...
  dotnet.lua             easy-dotnet (Roslyn LSP, tests, secrets)
  debug.lua              nvim-dap + netcoredbg
  testing.lua            jest
  ai.lua                 Copilot, 99
snippets/<filetype>.lua  personal LuaSnip snippets
```

To add a plugin, add a spec to the matching file in `lua/plugins/` (or create a new file there).
Plugin keymaps go in the spec's `keys` field so the plugin lazy-loads on first use.

## Key bindings

Leader is `<Space>`. Press `<Space>` and wait for which-key, or `<Space>sk` to search all keymaps.

| Prefix / key | What |
| --- | --- |
| `<leader>s…` | Telescope search (`sf` files, `sg` grep, `sw` word, `sh` help, `sn` nvim config) |
| `<leader><leader>` | Open buffers |
| `<leader>p…` | Project: `pf` files, `pg` git files, `ps` grep, `pa` harpoon marks |
| `gd` `gr` `gI` `gD` `gW` | LSP definition / references / implementation / declaration / workspace symbols |
| `<leader>rn` `<leader>ca` | Rename / code action |
| `<leader>rw` | Replace word under cursor in buffer |
| `<leader>ff` | Format buffer |
| `<leader>g…` | Git (fugitive): `gs` status, `gp` pull, `gc` checkout, `gnb` new story branch, `gb` blame |
| `<leader>h…` | Git hunks (gitsigns); `]c` / `[c` next/prev hunk |
| `<leader>lg` | LazyGit |
| `<leader>do` / `<leader>dc` | Diffview open / close |
| `F5` `F9` `F10` `F11` `F12` | Debug: continue, breakpoint, step over, into, out (Visual Studio layout) |
| `<leader>d…` | Debug: `db` breakpoint, `dB` conditional, `dC` run to cursor, `dr` REPL, `dt` terminate |
| `<C-p>` | .NET: run project |
| `<leader>x…` | Trouble lists |
| `<leader>a…` / `<C-S-j/k/l/;>` | Harpoon add / menu / jump to file 1-4 |
| `<leader>t…` | Terminal (`to` here, `tl` right, `tj` below, `th` hide) and toggles (`tt` transparency, `td` diagnostics, `ti` inlay hints, `tb` line blame, `tz` zen) |
| `<leader>9…` | 99 AI |
| `-` | Oil (parent directory) |
| `<leader>e` | Neo-tree |
| `<Esc><Esc>` | Leave terminal mode |
