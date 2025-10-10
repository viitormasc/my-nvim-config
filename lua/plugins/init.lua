-- return {
--   {
--     "stevearc/conform.nvim",
--     -- event = 'BufWritePre', -- uncomment for format on save
--     opts = require "configs.conform",
--   },
--
--   -- These are some examples, uncomment them if you want to see them work!
--   {
--     "neovim/nvim-lspconfig",
--     config = function()
--       require "configs.lspconfig"
--     end,
--   },
--
-- test new blink
-- { import = "nvchad.blink.lazyspec" },

-- {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	opts = {
-- 		ensure_installed = {
-- 			"vim", "lua", "vimdoc",
--      "html", "css"
-- 		},
-- 	},
-- },
-- }
--

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip").filetype_extend("javascriptreact", { "html" })
      require("luasnip").filetype_extend("javascriptreact", { "typescriptreact" })
      require("luasnip").filetype_extend("javascript", { "typescriptreact" })
      require("luasnip").filetype_extend("javascript", { "typescript" })
      require("luasnip").filetype_extend("typescriptreact", { "html" })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css"
      },

      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
  },
}
