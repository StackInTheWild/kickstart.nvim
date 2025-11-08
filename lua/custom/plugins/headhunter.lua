return {
  dir = '~/Repositories/GitHub/headhunter.nvim',
  config = function()
    require('headhunter').setup {
      -- Your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      next_conflict = ']g',
    }
  end,
}
