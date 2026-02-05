return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  opts = function(_, opts)
    local cmp = require("cmp")

    -- snippet engine
    opts.snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    }

    -- keymaps (extend, don’t replace)
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-Space>"] = cmp.mapping.complete(),
    })

    -- 🔥 ADD SOURCES HERE
    opts.sources = cmp.config.sources({
      -- { name = "99" },          -- ← THIS WAS MISSING
      { name = "nvim_lsp" },
      { name = "luasnip" },
      -- { name = "buffer" },
      { name = "path" },
    })
  end,
}
