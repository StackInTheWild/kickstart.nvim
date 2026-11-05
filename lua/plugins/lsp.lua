-- LSP for web/Lua. C# uses Roslyn through easy-dotnet (see lua/plugins/dotnet.lua).

-- Language servers to install with Mason and enable. Keys are nvim-lspconfig names.
---@type table<string, vim.lsp.Config>
local servers = {
  vtsls = {
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    settings = {
      typescript = {
        preferences = { importModuleSpecifierPreference = 'relative' },
      },
    },
  },
  cssls = {
    filetypes = { 'css', 'scss', 'less' },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
      },
    },
  },
}

-- Extra tools (formatters, etc.) to install with Mason
local tools = { 'stylua', 'prettierd' }

return {
  { -- Lua LSP for the Neovim config, runtime and plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP progress
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
          end
          local builtin = require 'telescope.builtin'

          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gW', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace symbols')
          map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          -- K (hover) and <C-s> (signature help) are Neovim defaults

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Highlight references of the word under the cursor
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('config-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('config-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'config-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>ti', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle [I]nlay hints')
          end
        end,
      })

      -- Advertise blink.cmp completion capabilities to every server. Done here (not lazily
      -- by blink) so the very first buffer opened from the command line gets them too.
      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

      local ensure_installed = vim.list_extend(vim.tbl_keys(servers), tools)
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
}
