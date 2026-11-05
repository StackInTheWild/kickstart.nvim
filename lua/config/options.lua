-- See `:help option-list`
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

opt.mouse = 'a'
opt.showmode = false -- already shown in the statusline

-- Sync clipboard with the OS. Scheduled because it can slow down startup.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

opt.breakindent = true
opt.undofile = true
opt.wrap = false

-- Case-insensitive search unless \C or a capital letter is used
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'
opt.colorcolumn = '120'
opt.cursorline = true
opt.scrolloff = 10

opt.updatetime = 250
opt.timeoutlen = 300 -- which-key pops up sooner

opt.splitright = true
opt.splitbelow = true

-- Show whitespace
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Live preview of :substitute
opt.inccommand = 'split'

-- Indentation defaults (guess-indent.nvim adjusts per buffer)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 8
opt.softtabstop = 0

-- UI
opt.termguicolors = true
vim.o.guifont = 'JetBrains Mono Medium:h10'

-- Copilot CLI (and other TUIs) misbehave with Neovim's default TERM in :terminal jobs
vim.env.TERM = 'xterm-256color'

-- Diagnostics, see `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}
