local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local c = luasnip.choice_node
local d = luasnip.dynamic_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node

local M = {}

local snippets = {
  s("log", fmt([[ console.log({}); ]], i(1))),
  s(
    "import",
    fmt([[ import {} from '{}' ]], {
      i(1),
      i(2),
    })
  ),
  s(
    "req",
    fmt([[const {} = require("{}");]], {
      -- util.get_last_word(1, "/"),
      d(2, util.get_word_choice, { 1 }, "/", "."),
      i(1, "module"),
    })
  ),
  s(
    "arrow",
    fmt([[({}) => {};]], {
      i(1),
      i(2, "// expression"),
    })
  ),
  s(
    "arf",
    fmt(
      [[
          ({}) => {{
            {}
          }}
        ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    "fn",
    fmt(
      [[
          const {} = ({}) => {{
            {}
          }}
        ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    "for",
    fmt(
      [[
          for (var {}) {{
            {}
          }}
        ]],
      {
        c(1, {
          sn(
            nil,
            fmt([[{} = {};{}]], {
              i(1, "i"),
              i(2, "0"),
              i(3),
            })
          ),
          sn(
            nil,
            fmt([[{} in {}]], {
              i(1, "element"),
              i(2, "object"),
            })
          ),
          sn(
            nil,
            fmt([[{} of {}]], {
              i(1, "element"),
              i(2, "array"),
            })
          ),
        }),
        i(2),
      }
    )
  ),
}

M.config = {
  javascript = snippets,
  js = snippets,
}

return M
