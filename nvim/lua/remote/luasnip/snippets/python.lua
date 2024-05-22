local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local dataclass = function(_, snip, old_state, _)
  local nodes = {}
  table.insert(nodes, snip.captures[1] == "d" and t { "@dataclass", "" } or t { "" })
  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

local init_fn
init_fn = function() return sn(nil, c(1, { t "", sn(1, { t ", ", i(1), d(2, init_fn) }) })) end

local init_params = function(args)
  local node = {}
  local a = args[1][1]
  if #a == 0 then
    table.insert(node, t { "", "\tpass" })
  else
    local cnt = 1
    for e in string.gmatch(a, " ?([^,]*) ?") do
      if #e > 0 then
        table.insert(node, t { "", "\tself." })
        table.insert(node, r(cnt, tostring(cnt), i(nil, e)))
        table.insert(node, t " = ")
        table.insert(node, t(e))
        cnt = cnt + 1
      end
    end
  end
  return sn(nil, node)
end

return {
  s({ trig = "import", name = "import statement", dscr = "Import statement" }, {
    c(1, {
      sn(nil, fmt("import {}", { r(1, "module") })),
      sn(nil, fmt("from {} import {}", { i(1, "namespace"), r(2, "module") })),
    }),
  }, {
    stored = {
      ["module"] = i(nil, "module"),
    },
  }),
  s(
    { trig = "dcl", name = "(data) class", dscr = "Declare <data>class" },
    fmt("{}class {}({}):\n\tdef __init__(self{}):{}", {
      d(1, dataclass, {}, {}),
      i(2, "Obj"),
      c(3, {
        t { "" },
        i(1, "object"),
      }),
      d(4, init_fn),
      d(5, init_params, { 4 }),
    })
  ),
  s(
    { trig = "fn", name = "function", dscr = "Declare function" },
    fmt("def {}({}):\n\t{}", {
      i(1, "function"),
      i(2, ""),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "for", name = "for loop", dscr = "For loop" },
    fmt("for {} in {}:\n{}", {
      i(1, "i"),
      i(2, "iterator"),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "init", name = "constructor", dscr = "Class constructor" },
    fmt("def __init__(self{}):{}", {
      d(1, init_fn),
      d(2, init_params, { 1 }),
    })
  ),
  s(
    { trig = "main", name = "script execution", dscr = "Script execution" },
    fmt('if __name__ == "__main__":\n{}', {
      d(1, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "try", name = "try - except", dscr = "Try - except block" },
    fmt("try:\n{}\nexcept {}:\n\t{}", {
      d(1, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
      i(2, "Exception"),
      i(3, "pass"),
    })
  ),
  s(
    { trig = "while", name = "while loop", dscr = "While loop" },
    fmt("while {}:\n{}", {
      i(1, "condition"),
      d(2, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  ts_postfix({
    trig = ".print",
    name = "log",
    dscr = "Print to stdout",
    reparseBuffer = "live",
    matchTSNode = ts_postfix_builtin.tsnode_matcher.find_topmost_types {
      "call_expression",
      "identifier",
      "expression_list",
      "expression_statement",
    },
  }, {
    c(1, {
      sn(nil, fmt("print({}{})", { i(1), l(l.LS_TSMATCH) })),
      sn(nil, fmta([[print(f"<>{<>}")]], { i(1), l(l.LS_TSMATCH) })),
    }),
  }),
}, {
  s({ trig = "print", name = "log", dscr = "Print to stdout" }, {
    c(1, {
      sn(nil, fmt("print({})", { i(1) })),
      sn(nil, fmta([[print(f"<>{<>}")]], { i(1), i(2) })),
    }),
  }, {
    condition = conds.line_begin,
  }),
}
