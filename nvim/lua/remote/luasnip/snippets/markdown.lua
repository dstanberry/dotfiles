local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local c = luasnip.choice_node
local d = luasnip.dynamic_node
local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt

local conds = require "luasnip.extras.expand_conditions"

local function repeat_list(delimiter)
  local ret
  ret = function()
    return sn(nil, {
      c(1, {
        t { "" },
        sn(nil, { t { "", delimiter }, i(1), d(2, ret, {}) }),
      }),
    })
  end
  return ret
end

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
  s(
    { trig = "cb" },
    fmt([=[- [{}]]=], {
      d(1, function()
        local options = { " ", "x", "-", "=", "_", "!", "+", "?" }
        for idx = 1, #options do
          options[idx] = t(options[idx])
        end
        return sn(nil, {
          c(1, options),
        })
      end),
    })
  ),
  s("l1", d(1, repeat_list "- ", {})),
  s("l2", d(1, repeat_list "-- ", {})),
  s("l3", d(1, repeat_list "--- ", {})),
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
  s(
    { trig = "*([2-6])", regTrig = true, hidden = true },
    { f(function(_, snip)
      return string.rep("*", tonumber(snip.captures[1])) .. " "
    end, {}) },
    {
      condition = conds.line_begin,
    }
  ),
  s(
    { trig = "-([2-6])", regTrig = true, hidden = true },
    { f(function(_, snip)
      return string.rep("-", tonumber(snip.captures[1])) .. " "
    end, {}) },
    {
      condition = conds.line_begin,
    }
  ),
}
