local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
-- local f = luasnip.function_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt

local stdclass = function(_, snip, old_state, _)
  local nodes = {}

  if snip.captures[1] == "d" then
    table.insert(
      nodes,
      c(1, {
        t { "" },
        sn(nil, { t { "\t" }, i(1, "attr") }),
      })
    )
  else
    table.insert(nodes, t { "", "\tdef __init__(self" })
    table.insert(
      nodes,
      c(1, {
        t { "" },
        sn(nil, { t { ", " }, i(1, "arg") }),
      })
    )
    table.insert(nodes, t { "):", "\t\t" })
    table.insert(nodes, i(2, "pass"))
  end

  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

local dataclass = function(_, snip, old_state, _)
  local nodes = {}

  table.insert(nodes, snip.captures[1] == "d" and t { "@dataclass", "" } or t { "" })
  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

local recursive_if
recursive_if = function()
  return sn(nil, {
    c(1, {
      t "",
      sn(nil, {
        t { "", "else:", "\t" },
        i(1, "// code"),
      }),
      sn(nil, {
        t { "", "elif " },
        i(1, "expr"),
        t { ":", "\t" },
        i(2, "// code"),
        d(3, recursive_if, {}),
      }),
    }),
  })
end

return {
  s(
    { trig = "imp[ort]", regTrig = true },
    fmt([[{}]], {
      c(1, {
        sn(nil, fmt([[import {}]], { i(1, "module-name") })),
        sn(nil, fmt([[from {} import {}]], { i(1, "defaultExport"), i(2, "*") })),
      }),
    })
  ),
  s(
    { trig = "(d?)cl", regTrig = true },
    fmt(
      [[
        {}class {}({}):
            {}
      ]],
      {
        d(1, dataclass, {}, {}),
        i(2, "Obj"),
        c(3, {
          t { "" },
          i(1, "object"),
        }),
        d(4, stdclass, {}, {}),
      }
    )
  ),
  s(
    { trig = "(def|fn)", regTrig = true },
    fmt(
      [[
        def {}({}):
        {}
      ]],
      {
        i(1, "function"),
        i(2, ""),
        d(3, util.saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
      }
    )
  ),
  s(
    { trig = "main" },
    fmt(
      [[
      if __name__ == "__main__":
          {}
      else:
          {}
      ]],
      {
        c(1, {
          sn(nil, { t { "exit(" }, i(1, "main()"), t { ")" } }),
          t { "pass" },
        }),
        i(2, "pass"),
      }
    )
  ),
  s("if", {
    t "if ",
    i(1, "expr"),
    t { ":", "" },
    d(2, util.saved_text, {}, { user_args = { { text = "// code", indent = true } } }),
    d(3, recursive_if, {}),
  }),
  s(
    { trig = "for" },
    fmt(
      [[
      for {} in {}:
      {}
      ]],
      {
        i(1, "i"),
        i(2, "iterator"),
        d(3, util.saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
      }
    )
  ),
  s(
    { trig = "while" },
    fmt(
      [[
      while {}:
      {}
      ]],
      {
        i(1, "condition"),
        d(2, util.saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
      }
    )
  ),
}, {
  s({ trig = "print" }, {
    t [[print(f"]],
    i(1),
    t [[")]],
  }),
}
