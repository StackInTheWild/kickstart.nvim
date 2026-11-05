return {
  { -- Main colorscheme
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000, -- load before all other start plugins
    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  },

  { -- Alternative colorscheme, loaded on `:colorscheme tokyonight`
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      transparent = true,
      styles = { sidebars = 'transparent', floats = 'transparent' },
    },
  },

  { -- Transparent background (state persists across sessions; toggle with <leader>tt)
    'xiyaowong/transparent.nvim',
    lazy = false,
    keys = {
      { '<leader>tt', '<cmd>TransparentToggle<CR>', desc = '[T]oggle [T]ransparency' },
    },
    opts = {},
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true, enabled = vim.g.have_nerd_font, opts = {} },

  { -- Shows pending keybinds
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        -- With a Nerd Font use which-key's default icons, otherwise plain text
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>9', group = '[9]9 AI' },
        { '<leader>a', group = 'H[a]rpoon' },
        { '<leader>b', group = '[B]uffers' },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ebug / [D]iff' },
        { '<leader>f', group = '[F]ormat' },
        { '<leader>g', group = '[G]it' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>p', group = '[P]roject' },
        { '<leader>r', group = '[R]ename / [R]eplace' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]erminal / [T]oggle' },
        { '<leader>x', group = 'Trouble' },
      },
    },
  },

  { -- Statusline, textobjects, surround
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        -- Avoid conflicts with 0.12 treesitter incremental selection (`:help treesitter-incremental-selection`)
        mappings = { around_next = 'aa', inside_next = 'ii' },
        n_lines = 500,
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      --  - sd'   - [S]urround [D]elete [']quotes
      --  - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  { -- Tabline
    'romgrk/barbar.nvim',
    version = '^1.0.0',
    event = 'VeryLazy',
    dependencies = { 'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
  },

  { -- Nicer cmdline, messages and notifications
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {
      lsp = {
        -- Render LSP markdown with Treesitter
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        -- blink.cmp already shows signature help
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    },
  },

  { -- Highlight TODO, NOTE, etc. in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Inline color previews (#ff0000, rgb(), ...)
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {},
  },

  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = { { '<leader>tz', '<cmd>ZenMode<CR>', desc = '[T]oggle [Z]en mode' } },
    opts = {},
  },
}
