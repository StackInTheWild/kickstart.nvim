local augroup = function(name)
  return vim.api.nvim_create_augroup('config-' .. name, { clear = true })
end

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'highlight-yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- In terminal buffers, scroll without `zz` (it makes the viewport snap back)
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Plain <C-u>/<C-d> in terminal buffers',
  group = augroup 'terminal-scroll',
  callback = function(args)
    vim.keymap.set('n', '<C-u>', '<C-u>', { buf = args.buf })
    vim.keymap.set('n', '<C-d>', '<C-d>', { buf = args.buf })
  end,
})
