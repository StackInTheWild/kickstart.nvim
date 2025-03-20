return {
  'ThePrimeagen/harpoon',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = true,
  keys = {
    { '<leader>aa', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Mark file with harpoon' },
    { '<leader>pa', '<cmd>Telescope harpoon marks<CR>', desc = 'Show harpoon marks' },
    { '<leader>am', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Toggle Harpoon menu' },
  },
}
