local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local function get_defguard()
  local filename = vim.fn.expand "%:t"
  filename = filename:gsub("-", "_"):gsub("%.(%w+)$", "_%1"):upper()
  return sn(nil, { i(1), i(2, filename) })
end

local M = {}

M.config = {
  c = {
    s("pragma", {
      t { "#ifndef " },
      d(1, get_defguard, {}),
      t { "", "#define " },
      util.same(1),
      t { "", "" },
      t { "", "" },
      i(2, "// code"),
      t { "", "", "#endif // " },
      util.same(1),
    }),
    s("switch", {
      t "switch (",
      i(1, "condition"),
      t { ") {", "\tcase " },
      i(2, "value"),
      t { ":", "\t\t" },
      i(3, "// code"),
      d(4, util.recursive_case, {}),
      t { "", "}" },
    }),
    s("case", {
      t { "case " },
      i(2, "value"),
      t { ":", "\t\t" },
      i(3, "// code"),
      d(4, util.recursive_case, {}),
    }),
    s("printf", {
      t "printf(",
      c(1, {
        sn(nil, { t '"', i(1), t '\\n", ', i(2) }),
        sn(nil, { t '"', i(1), t '\\n"' }),
        sn(nil, { t '"', i(1), t '"' }),
      }),
      t ");",
    }),
  },
}

return M
