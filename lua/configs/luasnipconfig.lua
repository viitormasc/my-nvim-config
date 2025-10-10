local luasnip = require "luasnip"
luasnip.filetype_extend("javascript", { "javascriptreact" })
luasnip.filetype_extend("javascript", { "typescript" })
luasnip.filetype_extend("javascript", { "typescriptreact" })
luasnip.filetype_extend("typescript", { "typescriptreact" })
luasnip.filetype_extend("javascript", { "html" })
luasnip.filetype_extend("typescript", { "html" })
require("luasnip/loaders/from_vscode").lazy_load()
