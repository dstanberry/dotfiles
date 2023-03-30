local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local function shebang(_, _)
  return sn(nil, {
    t(rutil.comment_string()[1]),
    t "!/usr/bin/env ",
    i(1, vim.bo.filetype),
  })
end

local function generate_lorem(words)
  local ret = {}
  for w = 1, words + 1, 1 do
    table.insert(ret, f(function() return vim.fn.systemlist("lorem --lines " .. w) end))
  end
  return ret
end

return {
  rutil.autopair.create("(", ")", rutil.autopair.punctuation_matched),
  rutil.autopair.create("{", "}", rutil.autopair.punctuation_matched),
  rutil.autopair.create("[", "]", rutil.autopair.punctuation_matched),
  rutil.autopair.create("<", ">", rutil.autopair.punctuation_matched),
  rutil.autopair.create("'", "'", rutil.autopair.char_matched),
  rutil.autopair.create('"', '"', rutil.autopair.char_matched),
  rutil.autopair.create("`", "`", rutil.autopair.char_matched),
  s({ trig = "date", name = "date", dscr = "Current date" }, { p(os.date, "%m-%d-%Y") }),
  s({ trig = "time", name = "time", dscr = "Current time" }, { p(os.date, "%H:%M") }),
  s({ trig = "lorem", name = "placeholder", dscr = "Placeholder text" }, c(1, generate_lorem(100))),
  s(
    {
      trig = "(%d+)lorem",
      regTrig = true,
      wordTrig = false,
      name = "placeholder",
      dscr = "Placeholder text (`n` lines)",
    },
    f(function(_, snip)
      local lines = snip.captures[1]
      if not tonumber(lines) then lines = 1 end
      return vim.fn.systemlist("lorem --lines " .. lines)
    end)
  ),
}, {
  s({ trig = "#!", name = "shebang", dscr = "Script interpreter" }, { d(1, shebang, {}) }),
  s(
    { trig = "{;", wordTrig = false, hidden = true },
    fmt(
      "{{\n{}\n}}",
      d(
        1,
        rutil.saved_text,
        {},
        { user_args = { { text = ("%s TODO"):format(rutil.comment_string()[1]), indent = true } } }
      )
    )
  ),
}
