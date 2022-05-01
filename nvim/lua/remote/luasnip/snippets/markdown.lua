local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local f = luasnip.function_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node

return {
  s(
    "meta",
    fmt(
      [[
        ---
        title: {}
        date: {} {}
        tags: [{}]
        ---

        {}
      ]],
      {
        i(1, "Work in progress"),
        f(function()
          return os.date "%m/%d/%Y"
        end, {}),
        f(function()
          return os.date "%H:%M"
        end, {}),
        i(2, "fleeting"),
        i(3),
      }
    )
  ),
  s(
    "link",
    fmt([[ [{}]({}) ]], {
      i(1),
      f(function(_, snip)
        return snip.env.TM_SELECTED_TEXT[1] or {}
      end, {}),
    })
  ),
}, {
  s(
    "```",
    fmt(
      [[
        ```{}
        {}
        ```
      ]],
      {
        i(1, "lang"),
        f(function(_, snip)
          local tmp = {}
          tmp = snip.env.TM_SELECTED_TEXT
          tmp[0] = nil
          return tmp or {}
        end, {}),
      }
    )
  ),
}
