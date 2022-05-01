local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local f = luasnip.function_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

-- local fmt = luasnip.extras_fmt.fmt
local p = luasnip.extras.partial

local function shebang(_, _)
  local cstring = vim.split(vim.bo.commentstring, "%s", true)[1]
  if cstring == "/*" then
    cstring = "//"
  end
  cstring = vim.trim(cstring)
  return sn(nil, {
    t(cstring),
    t "!/usr/bin/env ",
    i(1, vim.bo.filetype),
  })
end

local function generate_lorem(words)
  local ret = {}
  for w = 1, words + 1, 1 do
    table.insert(
      ret,
      f(function()
        return vim.fn.systemlist("lorem --lines " .. w)
      end)
    )
  end
  return ret
end

return {
  util.autopair.create("(", ")", util.autopair.punctuation_matched),
  util.autopair.create("{", "}", util.autopair.punctuation_matched),
  util.autopair.create("[", "]", util.autopair.punctuation_matched),
  util.autopair.create("<", ">", util.autopair.punctuation_matched),
  util.autopair.create("'", "'", util.autopair.char_matched),
  util.autopair.create('"', '"', util.autopair.char_matched),
  util.autopair.create("`", "`", util.autopair.char_matched),
  s({ trig = "date" }, { p(os.date, "%m-%d-%Y") }),
  s({ trig = "time" }, { p(os.date, "%H:%M") }),
  s({ trig = "lorem" }, c(1, generate_lorem(100))),
  s(
    { trig = "(%d+)lorem", regTrig = true },
    f(function(_, snip)
      local lines = snip.captures[1]
      if not tonumber(lines) then
        lines = 1
      end
      return vim.fn.systemlist("lorem --lines " .. lines)
    end)
  ),
}, {
  s({ trig = "#!" }, { d(1, shebang, {}) }),
  s({ trig = "{;", wordTrig = false, hidden = true }, {
    t "{",
    t { "", "\t" },
    i(1),
    t { "", "}" },
  }),
}
