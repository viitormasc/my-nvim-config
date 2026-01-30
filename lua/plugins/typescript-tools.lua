return {
  "pmizio/typescript-tools.nvim",
  enabled = true,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "typescript", "typescriptreact" },
  opts = {
    on_attach = function(client, bufnr)
      -- Basic keymaps
      local opts = { buffer = bufnr }
      vim.keymap.set("n", "<leader>to", ":TSToolsOrganizeImports<CR>", opts)
      vim.keymap.set("n", "<leader>ta", ":TSToolsAddMissingImports<CR>", opts)
      vim.keymap.set("n", "<leader>tf", ":TSToolsFixAll<CR>", opts)
      vim.keymap.set("n", "<leader>tr", ":TSToolsRenameFile<CR>", opts)
      vim.keymap.set("n", "<leader>tR", ":TSToolsFileReferences<CR>", opts)
      vim.keymap.set("n", "<leader>ts", ":TSToolsSortImports<CR>", opts)
      vim.keymap.set("n", "<leader>tu", ":TSToolsRemoveUnused<CR>", opts)
      vim.keymap.set("n", "<leader>tU", ":TSToolsRemoveUnusedImports<CR>", opts)
      vim.keymap.set("n", "<leader>tg", ":TSToolsGoToSourceDefinition<CR>", opts)
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  },
  config = function(_, opts)
    require("typescript-tools").setup(opts)
  end,
}
