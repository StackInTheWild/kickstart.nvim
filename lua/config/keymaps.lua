-- Global keymaps that don't depend on a plugin.
-- Plugin keymaps are declared in the `keys` field of their spec in lua/plugins/.
local map = vim.keymap.set

-- Neovim 0.11+ ships global `gr*` LSP mappings (grn, grr, gra, ...). They make our
-- `gr` (references) wait for 'timeoutlen', so remove them. We define our own LSP maps
-- in lua/plugins/lsp.lua.
for _, lhs in ipairs { 'grn', 'grr', 'gri', 'grt', 'grx' } do
  pcall(vim.keymap.del, 'n', lhs)
end
pcall(vim.keymap.del, { 'n', 'x' }, 'gra')

-- General
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('i', 'jk', '<Esc>l', { desc = 'Escape insert mode' })
map('n', '<leader>w', '<cmd>w!<CR>', { desc = '[W]rite buffer' })
map('n', '<leader>q', '<cmd>bd!<CR>', { desc = '[Q]uit (delete) buffer' })
map('n', '<leader>bd', '<cmd>%bd|e#|bd#<CR>', { desc = '[B]uffers: [D]elete all others' })
map('n', '<leader>so', '<cmd>source %<CR>', { desc = '[S]ource current file' })

-- Keep the cursor centered while paging
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- Visual mode: move selected lines, keep selection after indenting
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('v', '>', '>gv')
map('v', '<', '<gv')

-- Registers
map('x', '<leader>p', [["_dP]], { desc = '[P]aste without yanking selection' })
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[Y]ank to system clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = '[Y]ank line to system clipboard' })
map('x', '<leader>d', [["_d]], { desc = '[D]elete without yanking' })

-- Replace the word under the cursor in the whole buffer
map('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[R]eplace [W]ord in buffer' })

-- Windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<M-k>', '<cmd>resize -1<CR>', { desc = 'Decrease window height' })
map('n', '<M-j>', '<cmd>resize +1<CR>', { desc = 'Increase window height' })
map('n', '<M-h>', '<cmd>vertical resize -1<CR>', { desc = 'Decrease window width' })
map('n', '<M-l>', '<cmd>vertical resize +1<CR>', { desc = 'Increase window width' })

-- Terminal
-- Only a double <Esc> leaves terminal mode, so a single <Esc> still reaches TUIs
-- running inside the terminal (lazygit, Copilot CLI, fzf, ...).
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<leader>to', '<cmd>terminal<CR>', { desc = '[T]erminal: [O]pen here' })
map('n', '<leader>tl', '<cmd>vsplit | terminal<CR>i', { desc = '[T]erminal: open right' })
map('n', '<leader>tj', '<cmd>split | terminal<CR>i', { desc = '[T]erminal: open below' })
map('n', '<leader>th', '<cmd>hide<CR>', { desc = '[T]erminal: [H]ide window' })

-- Diagnostics
map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle [D]iagnostics' })

-- tmux
map('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'tmux sessionizer' })
