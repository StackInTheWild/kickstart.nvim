local function call(mod, fn)
  return function()
    require(mod)[fn]()
  end
end

-- Harpoon: jump to the n-th marked file
local function nav(n)
  return function()
    require('harpoon.ui').nav_file(n)
  end
end

return {
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- Detect tabstop and shiftwidth automatically

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  { 'mg979/vim-visual-multi', event = 'VeryLazy' },

  { -- File explorer as a buffer
    'stevearc/oil.nvim',
    lazy = false, -- so `nvim .` opens oil
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Open parent directory (Oil)' },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = { show_hidden = true },
    },
  },

  { -- File tree
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    cmd = 'Neotree',
    keys = {
      { '<leader>e', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = { ['<leader>e'] = 'close_window' },
        },
      },
    },
  },

  { -- Quick file marks (harpoon v1)
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    keys = {
      { '<leader>aa', call('harpoon.mark', 'add_file'), desc = 'H[a]rpoon: [A]dd file' },
      { '<leader>am', call('harpoon.ui', 'toggle_quick_menu'), desc = 'H[a]rpoon: [M]enu' },
      { '<leader>pa', '<cmd>Telescope harpoon marks<CR>', desc = 'Harpoon marks (Telescope)' },
      { '<C-S-j>', nav(1), desc = 'Harpoon file 1' },
      { '<C-S-k>', nav(2), desc = 'Harpoon file 2' },
      { '<C-S-l>', nav(3), desc = 'Harpoon file 3' },
      { '<C-S-;>', nav(4), desc = 'Harpoon file 4' },
    },
    config = function()
      require('harpoon').setup {}
      require('telescope').load_extension 'harpoon'
    end,
  },

  { -- Diagnostics / symbols / quickfix lists
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP Definitions / references (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List (Trouble)' },
    },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
}
