#vim.keymap.set('n', '<leader>bd', ':%bd|e#<CR>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>to', ':terminal<CR>', { desc = 'Open a new terminal' })
vim.keymap.set('n', '<leader>th', ':hide<CR>', { desc = 'Hide the current terminal' })
vim.keymap.set('n', '<leader>w', ':w!<CR>', { desc = 'Save the current document' })
vim.keymap.set('n', '<leader>q', ':bd!<CR>', { desc = 'Delete the current buffer' })
vim.keymap.set('n', '<leader>so', ':so<CR>', { desc = 'Source update' })
vim.keymap.set('i', 'jk', '<Esc>l', { desc = 'Escape insert mode' })

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- Primeagen remaps
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

vim.keymap.set('n', '<leader>ss', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set('n', '<M-k>', ':1winc-<cr>')
vim.keymap.set('n', '<M-j>', ':1winc+<cr>')
vim.keymap.set('n', '<M-h>', ':1winc<<cr>')
vim.keymap.set('n', '<M-l>', ':1winc><cr>')

vim.keymap.set('n', '<leader>cr', ':source %<cr>', { desc = 'Refresh config' })
vim.keymap.set('n', '<leader>yd', 'ggVGy', { desc = 'Refresh config' })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
