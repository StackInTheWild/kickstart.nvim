return {
  { -- Fuzzy finder (files, lsp, etc). Press <C-/> (insert) or ? (normal) in a picker for its keymaps.
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = function(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { desc = desc })
      end

      map('<leader>sh', builtin.help_tags, '[S]earch [H]elp')
      map('<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
      map('<leader>sf', builtin.find_files, '[S]earch [F]iles')
      map('<leader>ss', builtin.builtin, '[S]earch [S]elect Telescope')
      map('<leader>sw', builtin.grep_string, '[S]earch current [W]ord')
      map('<leader>sg', builtin.live_grep, '[S]earch by [G]rep')
      map('<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics')
      map('<leader>sr', builtin.resume, '[S]earch [R]esume')
      map('<leader>s.', builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
      map('<leader><leader>', builtin.buffers, '[ ] Find existing buffers')

      map('<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, '[/] Fuzzily search in current buffer')

      map('<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, '[S]earch [/] in Open Files')

      map('<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, '[S]earch [N]eovim files')

      -- Project-style aliases
      map('<leader>pf', builtin.find_files, '[P]roject [F]iles')
      map('<leader>pg', builtin.git_files, '[P]roject [G]it files')
      map('<leader>ps', function()
        builtin.grep_string { search = vim.fn.input 'Grep > ' }
      end, '[P]roject [S]earch')
      map('<leader>vh', builtin.help_tags, '[V]im [H]elp')
    end,
  },
}
