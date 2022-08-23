local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt
local rep = luasnip.extras.rep

return {
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
      { d(2, util.repeat_node_segment, { 1 }, { user_args = { "/", "." } }), i(1, "module") }
    )
  ),
  s(
    "fn",
    fmt(
      [[
        function {}({}) {{
        {}
        }}
      ]],
      {
        i(1, "function"),
        i(2, ""),
        d(3, util.saved_text, {}, { user_args = { { text = "// code", indent = true } } }),
      }
    )
  ),
  s("switch", {
    t "switch (",
    i(1, "condition"),
    t { ") {", "\tcase " },
    i(2, "value"),
    t { ":", "\t\t" },
    d(3, util.saved_text, {}, { user_args = { { text = "// code", indent = true } } }),
    d(4, util.recursive_case, {}),
    t { "", "}" },
  }),
  s(
    "while",
    fmt(
      [[
        while({}) {{
        {}
        }}
      ]],
      {
        i(1, "condition"),
        d(2, util.saved_text, {}, { user_args = { { indent = true } } }),
      }
    )
  ),
  s(
    "for",
    fmt(
      [[
        for ({} {}) {{
          {}
        }}
      ]],
      {
        c(1, {
          t "let",
          t "const",
        }),
        c(2, {
          sn(
            nil,
            fmt([[{} = 0; {} < {}; {}++]], {
              i(1, "i"),
              d(2, util.repeat_node_segment, { 1 }, { user_args = { " " } }),
              c(3, { i(1, "num"), sn(1, { i(1, "arr"), t ".length" }) }),
              rep(1),
            })
          ),
          sn(nil, fmt([[{} in {}]], { i(1, "element"), i(2, "array") })),
          sn(nil, fmt([[{} of {}]], { i(1, "element"), i(2, "iterable") })),
        }),
        i(3),
      }
    )
  ),
  s("if", {
    t "if (",
    i(1, "expr"),
    t { ") {", "" },
    d(2, util.saved_text, {}, { user_args = { { text = "// code", indent = true } } }),
    d(3, util.recursive_if, {}),
    t { "", "}" },
  }),
  s(
    "try",
    fmt(
      [[
        try {{
        {}
        catch ({}) {{
          {}
        }}
      ]],
      {
        d(1, util.saved_text, {}, { user_args = { { indent = true } } }),
        i(2, "err"),
        i(3, "console.error(err)"),
      }
    )
  ),
  s("log", fmt([[console.log({});]], i(1))),
}, {
  s(
    ">>",
    fmt([[{} => {}]], {
      c(1, {
        sn(nil, fmt([[({})]], { i(1) })),
        sn(nil, fmt([[{} {} = ({})]], { c(1, { t "var", t "const" }), i(2), i(3) })),
      }),
      c(2, {
        sn(nil, fmt([[{};]], { i(1) })),
        sn(
          nil,
          fmt(
            [[
              {{
                {}
              }}
            ]],
            {
              d(1, util.saved_text, {}, { user_args = { { indent = true } } }),
            }
          )
        ),
      }),
    })
  ),
}
