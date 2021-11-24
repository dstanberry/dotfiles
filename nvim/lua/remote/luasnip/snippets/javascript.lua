local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local fmt = luasnip.extras_fmt.fmt
local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node

local M = {}

M.config = {
  javascript = {
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
        util.get_last_word(1, "/"),
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
  },
}

return M
