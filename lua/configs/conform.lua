local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
  },

  -- format_on_save = function(bufnr)
  --   if vim.bo[bufnr].filetype == "lua" then
  --     return false
  --   end
  --   return {
  --     timeout_ms = 500,
  --     lsp_fallback = true,
  --   }
  -- end,
}

return options
