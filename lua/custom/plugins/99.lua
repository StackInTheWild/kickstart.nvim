return {
  'ThePrimeagen/99',
  config = function()
    local _99 = require('99')
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },
      md_files = {
        'AGENT.md',
      },
      completion = {
        source = 'native',
      },
    })

    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '[9] Visual replace with AI' })

    vim.keymap.set('n', '<leader>9x', function()
      _99.stop_all_requests()
    end, { desc = '[9] Stop all requests' })

    vim.keymap.set('n', '<leader>9s', function()
      _99.search()
    end, { desc = '[9] Search with AI' })

    vim.keymap.set('n', '<leader>9o', function()
      _99.open()
    end, { desc = '[9] Open last interaction' })

    vim.keymap.set('n', '<leader>9l', function()
      _99.view_logs()
    end, { desc = '[9] View logs' })

    vim.keymap.set('n', '<leader>9c', function()
      _99.clear_previous_requests()
    end, { desc = '[9] Clear previous requests' })

    -- Telescope extensions (model/provider switcher)
    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end, { desc = '[9] Select model' })

    vim.keymap.set('n', '<leader>9p', function()
      require('99.extensions.telescope').select_provider()
    end, { desc = '[9] Select provider' })
  end,
}
