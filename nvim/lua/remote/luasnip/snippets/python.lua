local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

local dataclass = function(_, snip, old_state, _)
  local nodes = {}
  table.insert(nodes, snip.captures[1] == "d" and t { "@dataclass", "" } or t { "" })
  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

local init = function(args, parent)
  local nodes = { t "def __init__(self" }
  local argc = parent.argc
  if not argc then
    parent.argc = 1
    argc = 1
  end
  local index = 1
  for _ = 1, argc do
    vim.list_extend(nodes, { t ", ", i(index, "arg" .. index) })
    index = index + 1
  end
  nodes[#nodes + 1] = t { ")", "" }
  for j = 1, argc do
    vim.list_extend(nodes, {
      t "\t self.",
      i(index, "arg" .. j),
      t " = ",
      rep(j),
      t { "", "" },
    })
    index = index + 1
  end
  nodes[#nodes] = nil
  return sn(nil, nodes)
end

return {
  s(
    { trig = "im[port]", regTrig = true },
    fmt("{}", {
      c(1, {
        sn(nil, fmt("import {}", { i(1, "module-name") })),
        sn(nil, fmt("from {} import {}", { i(1, "defaultExport"), i(2, "*") })),
      }),
    })
  ),
  s(
    { trig = "(d?)cl", regTrig = true },
    fmt("{}class {}({}):\n\t{}", {
      d(1, dataclass, {}, {}),
      i(2, "Obj"),
      c(3, {
        t { "" },
        i(1, "object"),
      }),
      d(4, init, {}, {
        user_args = {
          function(parent)
            vim.ui.input({ prompt = "Number of args: " }, function(argc)
              parent.argc = math.max(argc, 1)
            end)
          end,
        },
      }),
    })
  ),
  s(
    { trig = "fn" },
    fmt("def {}({}):\n\t{}", {
      i(1, "function"),
      i(2, ""),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "for" },
    fmt("for {} in {}:\n{}", {
      i(1, "i"),
      i(2, "iterator"),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "init" },
    d(1, init, {}, {
      user_args = {
        function(parent)
          vim.ui.input({ prompt = "Number of args: " }, function(argc)
            parent.argc = math.max(argc, 1)
          end)
        end,
      },
    })
  ),
  s(
    { trig = "main" },
    fmt('if __name__ == "__main__":\n{}', {
      d(1, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "try" },
    fmt("try:\n{}\nexcept {}:\n\t{}", {
      d(1, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
      i(2, "Exception"),
      i(3, "pass"),
    })
  ),
  s(
    { trig = "while" },
    fmt("while {}:\n{}", {
      i(1, "condition"),
      d(2, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
}, {
  s({ trig = "print" }, fmt([[print(f"{}")]], { i(1) }), {
    condition = conds.line_begin,
  }),
}
