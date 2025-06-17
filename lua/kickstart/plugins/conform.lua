return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt" },
      go = { "goimports", "gofmt" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
}
