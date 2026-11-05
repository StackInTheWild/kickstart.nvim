return {
  { -- Snippet engine
    'L3MON4D3/LuaSnip',
    version = '2.*',
    lazy = true,
    build = (function()
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip').setup {}
      require('luasnip.loaders.from_vscode').lazy_load()
      -- Personal snippets: snippets/<filetype>.lua
      require('luasnip.loaders.from_lua').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }
    end,
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip', 'folke/lazydev.nvim' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets' },
        providers = {
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
