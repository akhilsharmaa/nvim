return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        -- Remove dart from conform, let LSP handle it
        -- dart = { "dart_format" },
        go = { 'gofmt', 'goimports' },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true, -- This will use dartls LSP formatting
      },
      notify_on_error = true,
    }
  end,
}
