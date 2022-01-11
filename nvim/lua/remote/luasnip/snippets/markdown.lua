local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local f = luasnip.function_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node

local M = {}

M.config = {
  markdown = {
    s(
      "block",
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
    s(
      "link",
      fmt([[ [{}]({}) ]], {
        i(1),
        f(function(_, snip)
          return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
      })
    ),
    s(
      "meta",
      fmt(
        [[
          ---
          # {}

          **created**: *{} {}*

          **tags**: *[{}]*
          ---

          {}
        ]],
        {
          i(1, "Title"),
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
  },
}

return M
