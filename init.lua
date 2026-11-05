-- Neovim configuration entry point.
--
-- Layout:
--   lua/config/options.lua   editor options
--   lua/config/keymaps.lua   global keymaps (plugin keymaps live with their plugin spec)
--   lua/config/autocmds.lua  autocommands
--   lua/config/lazy.lua      lazy.nvim bootstrap + setup
--   lua/plugins/*.lua        plugin specs, grouped by domain (auto-imported)
--   snippets/*.lua           LuaSnip snippets, one file per filetype
--
-- Requires Neovim 0.12+. Run `:checkhealth config` to verify external tools.

-- Leader must be set before lazy.nvim loads any plugin.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- vim: ts=2 sts=2 sw=2 et
