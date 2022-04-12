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

local M = {}

local snippets = {
  s("log", fmt([[console.log({});]], i(1))),
  s(
    { trig = "imp[ort]", regTrig = true },
    fmt([[import {};]], {
      c(1, {
        sn(nil, fmt([["{}"]], { i(1, "module-name") })),
        sn(nil, fmt([[{} from "{}"]], { i(1, "defaultExport"), i(2, "module-name") })),
      }),
    })
  ),
  s(
    { trig = "req[uire]", regTrig = true },
    fmt(
      [[const {} = require("{}");]],
      { d(2, util.get_word_choice, { 1 }, { user_args = { "/", "." } }), i(1, "module") }
    )
  ),
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
            { i(1) }
          )
        ),
      }),
    })
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
              d(2, util.get_word_choice, { 1 }, { user_args = { " " } }),
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
    t { ") {", "\t" },
    i(2, "// code"),
    d(3, util.recursive_if, {}),
    t { "", "}" },
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
}

M.config = {
  javascript = snippets,
  js = snippets,
}

return M
