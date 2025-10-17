return {
  "rest-nvim/rest.nvim",
  ft = "http",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "MunifTanjim/nui.nvim"
  },
  opts = {
    rocks = {
      hererocks = false, -- Use system luarocks
      enabled = true     -- But enable rocks support
    }
  },
  config = function()
    require("rest-nvim").setup({
      -- Your config here
    })
  end
}
