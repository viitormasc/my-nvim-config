return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "lua" then
          return false
        end
        return { lsp_fallback = true, timeout_ms = 1000 }
      end,
    },
  },
}
