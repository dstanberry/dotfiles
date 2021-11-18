local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node

local M = {}

M.config = {
  javascript = {
    s({ trig = "log" }, {
      t "console.log(",
      i(1),
      t ");",
      i(0),
    }),
  },
  s({ trig = "require" }, {
    t "const ",
    i(2, "name"),
    t " = require('",
    i(1, "module"),
    t "');",
  }),
  s({ trig = "lam" }, {
    t { "() => " },
    i(0),
  }),
  s({ trig = "lf" }, {
    t { "() => {", "\t" },
    i(0),
    t { "", "}" },
  }),
  s({ trig = "fn" }, {
    t "const ",
    i(1),
    t " = (",
    i(2),
    t ") => {",
    t { "", "\t" },
    i(0),
    t { "", "}" },
  }),
  s({ trig = "import" }, {
    t "import ",
    i(1),
    t " from ",
    t "'",
    i(2),
    t "'",
  }),
}

return M
