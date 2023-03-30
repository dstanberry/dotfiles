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
  s(
    { trig = "im[port]", regTrig = true, name = "import statement", dscr = "Import statement" },
    fmt("{}", {
      c(1, {
        sn(nil, fmt("import {}", { i(1, "module-name") })),
        sn(nil, fmt("from {} import {}", { i(1, "defaultExport"), i(2, "*") })),
      }),
    })
  ),
  s(
    { trig = "(d?)cl", regTrig = true, name = "(data) class", dscr = "Declare <data>class" },
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
}, {
  s({ trig = "print", name = "log", dscr = "Print to stdout" }, fmt([[print(f"{}")]], { i(1) }), {
    condition = conds.line_begin,
  }),
}
