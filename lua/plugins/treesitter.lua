local parsers = {
  'bash',
  'c',
  'c_sharp',
  'css',
  'diff',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'scss',
  'terraform',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return
  end
  vim.treesitter.start(buf, language)
  if vim.treesitter.query.get(language, 'indents') ~= nil then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install(parsers)

      local available_parsers = ts.get_available()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('config-treesitter', { clear = true }),
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if vim.tbl_contains(ts.get_installed 'parsers', language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- Auto-install missing parsers on first use
            ts.install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },

  { -- Sticky function/class headers
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      max_lines = 0,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
    },
  },

  { -- Auto close/rename HTML & JSX tags
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}
