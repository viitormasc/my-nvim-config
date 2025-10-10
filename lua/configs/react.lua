local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("mycomp", {
    t("import React from 'react';"),
    t({ "", "" }),
    t("const "), i(1, "MyComponent"), t(" = () => {"),
    t({ "", "  return (" }),
    t({ "    <div>" }),
    t({ "      <h1>" }), i(2, "Hello from Component"), t("</h1>"),
    t({ "    </div>" }),
    t({ "  );" }),
    t({ "};" }),
    t({ "" }, "export default "), i(1), t(";"),
  }),
}
