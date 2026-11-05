local prettier = { 'prettierd', 'prettier', stop_after_first = true }

return {
  { -- Autoformat (format on save + <leader>ff)
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>ff',
        function()
          require('conform').format { async = false, timeout_ms = 5000, lsp_format = 'fallback' }
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- No LSP fallback for languages without a standardized style
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        css = prettier,
        scss = prettier,
        html = prettier,
        json = prettier,
        yaml = prettier,
        markdown = prettier,
      },
    },
  },
}
