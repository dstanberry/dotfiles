local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

return {
  s(
    { trig = "fn" },
    fmt("function {}({}) {{\n{}\n}}", {
      i(1, "main"),
      i(2, ""),
      d(3, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "for" },
    fmt("for ({} {}) {{\n{}\n}}", {
      c(1, {
        t "let",
        t "const",
      }),
      c(2, {
        sn(
          nil,
          fmt("{} = 0; {} < {}; {}++", {
            i(1, "i"),
            d(2, rutil.repeat_node_segment, { 1 }, { user_args = { " " } }),
            c(3, { i(1, "num"), sn(1, { i(1, "arr"), t ".length" }) }),
            rep(1),
          })
        ),
        sn(nil, fmt("{} in {}", { i(1, "element"), i(2, "array") })),
        sn(nil, fmt("{} of {}", { i(1, "element"), i(2, "iterable") })),
      }),
      i(3),
    })
  ),
  s(
    { trig = "im[port]", regTrig = true },
    fmt([[import {};]], {
      c(1, {
        sn(nil, fmt([["{}"]], { i(1, "module-name") })),
        sn(nil, fmt([[{} from "{}"]], { i(1, "defaultExport"), i(2, "module-name") })),
      }),
    })
  ),
  s(
    { trig = "re[quire]", regTrig = true },
    fmt(
      [[const {} = require("{}");]],
      { d(2, rutil.repeat_node_segment, { 1 }, { user_args = { "/", "." } }), i(1, "module") }
    )
  ),
  s({ trig = "switch" }, rutil.switch_case_node),
  s(
    { trig = "try" },
    fmt("try {{\n{}\ncatch ({}) {{\n\t{}\n}}", {
      d(1, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
      i(2, "err"),
      i(3, "console.error(err)"),
    })
  ),
  s(
    { trig = "while" },
    fmt("while({}) {{\n{}\n}}", {
      i(1, "condition"),
      d(2, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
    })
  ),
}, {
  s(
    { trig = ">>", wordTrig = false, hidden = true },
    fmt("{} => {}", {
      c(1, {
        sn(nil, fmt("({})", { i(1) })),
        sn(nil, fmt("{} {} = ({})", { c(1, { t "var", t "const" }), i(2), i(3) })),
      }),
      c(2, {
        sn(nil, fmt("{};", { i(1) })),
        sn(
          nil,
          fmt("{{\n{}\n}}", {
            d(1, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
          })
        ),
      }),
    })
  ),
  s({ trig = "log" }, fmt([[console.log({});]], i(1)), {
    condition = conds.line_begin,
  }),
}
