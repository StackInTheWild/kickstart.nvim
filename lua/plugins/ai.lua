--- Returns a function that calls require(mod)[fn]() (lazy-loads the module on use)
local function call(mod, fn)
  return function()
    require(mod)[fn]()
  end
end

return {
  { 'github/copilot.vim', event = 'InsertEnter', cmd = 'Copilot' },

  {
    'ThePrimeagen/99',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = {
      { '<leader>9v', call('99', 'visual'), mode = 'v', desc = '[9] Visual replace with AI' },
      { '<leader>9x', call('99', 'stop_all_requests'), desc = '[9] Stop all requests' },
      { '<leader>9s', call('99', 'search'), desc = '[9] Search with AI' },
      { '<leader>9o', call('99', 'open'), desc = '[9] Open last interaction' },
      { '<leader>9l', call('99', 'view_logs'), desc = '[9] View logs' },
      { '<leader>9c', call('99', 'clear_previous_requests'), desc = '[9] Clear previous requests' },
      { '<leader>9m', call('99.extensions.telescope', 'select_model'), desc = '[9] Select model' },
      { '<leader>9p', call('99.extensions.telescope', 'select_provider'), desc = '[9] Select provider' },
    },
    config = function()
      local _99 = require '99'
      _99.setup {
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. vim.fs.basename(vim.uv.cwd()) .. '.99.debug',
          print_on_error = true,
        },
        md_files = { 'AGENT.md' },
        completion = { source = 'native' },
      }
    end,
  },
}
