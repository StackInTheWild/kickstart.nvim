vim.keymap.set('n', '<leader>bd', ':%bd|e#<CR>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>to', ':terminal<CR>', { desc = 'Open a new terminal' })
vim.keymap.set('n', '<leader>th', ':hide<CR>', { desc = 'Hide the current terminal' })
vim.keymap.set('n', '<leader>w', ':w!<CR>', { desc = 'Save the current document' })
vim.keymap.set('n', '<leader>q', ':bd!<CR>', { desc = 'Delete the current buffer' })
vim.keymap.set('n', '<leader>so', ':so<CR>', { desc = 'Source update' })
vim.keymap.set('i', 'jk', '<Esc>l', { desc = 'Escape insert mode' })

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- Use plain scroll in terminal buffers (zz causes viewport snap-back)
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.keymap.set('n', '<C-u>', '<C-u>', { buffer = true })
    vim.keymap.set('n', '<C-d>', '<C-d>', { buffer = true })
  end,
})

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

vim.keymap.set('n', '<leader>gnb', function()
  local name = vim.fn.input 'Branch name: story-'
  if name == '' then
    return
  end
  name = name:gsub('%s', '-')
  vim.cmd('Git checkout -b story-' .. name)
end, { desc = '[G]it [N]ew [B]ranch (story-)' })
