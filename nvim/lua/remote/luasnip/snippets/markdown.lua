local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

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
    fmt("---\ntitle: {}\ndate: {} {}\ntags: [{}]\n---\n\n{}", {
      i(1, "Work in progress"),
      f(function()
        return os.date "%m/%d/%Y"
      end, {}),
      f(function()
        return os.date "%H:%M"
      end, {}),
      i(2, "fleeting"),
      i(3),
    })
  ),
  s(
    { trig = "link" },
    fmt("[{}]({})", {
      i(1),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
  s(
    { trig = "img" },
    fmt("![{}]({})", {
      i(1),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
  s(
    { trig = "cb" },
    fmt("- [{}]", {
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
    fmt("```{}\n{}\n```\n{}", {
      i(1, "lang"),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
      i(0),
    })
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
