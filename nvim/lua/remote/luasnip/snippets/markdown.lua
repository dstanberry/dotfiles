local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local s = luasnip.snippet
local d = luasnip.dynamic_node
local f = luasnip.function_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node

return {
  s(
    { trig = "meta" },
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
    { trig = "link" },
    fmt([=[[{}]({})]=], {
      i(1),
      d(2, util.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
  s(
    { trig = "img" },
    fmt([=[![{}]({})]=], {
      i(1),
      d(2, util.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
}, {
  s(
    { trig = "```", wordTrig = false, hidden = true },
    fmt(
      [[
      ```{}
      {}
      ```
      {}
      ]],
      {
        i(1, "lang"),
        d(2, util.saved_text, {}, { user_args = { { indent = false } } }),
        i(0),
      }
    )
  ),
}
