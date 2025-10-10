return {
  {
    "mbbill/undotree",
    lazy = false, -- carrega apenas ao usar o comando
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
    },
    init = function()
      -- Configurações via variáveis globais Vim
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
