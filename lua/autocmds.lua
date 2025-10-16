require "nvchad.autocmds"
-- Auto-start Tailwind CSS LSP when opening relevant files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
  callback = function()
    vim.schedule(function()
      -- Check if Tailwind LSP is not already running
      local clients = vim.lsp.get_active_clients({ name = "tailwindcss" })
      if #clients == 0 then
        vim.cmd("LspStart tailwindcss")
        print("🚀 Tailwind CSS LSP started!")
      end
    end)
  end,
})

-- Optional: Also start when opening Neovim if a relevant file is already open
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      local filetype = vim.bo.filetype
      local relevant_ft = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        html = true
      }

      if relevant_ft[filetype] then
        local clients = vim.lsp.get_active_clients({ name = "tailwindcss" })
        if #clients == 0 then
          vim.cmd("LspStart tailwindcss")
          print("🚀 Tailwind CSS LSP started!")
        end
      end
    end)
  end,
})
