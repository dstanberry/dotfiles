local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local f = luasnip.function_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt
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
        return vim.fn.systemlist("lorem_text --words " .. w)
      end)
    )
  end
  return ret
end

return {
  util.autopair("(", ")", util.char_count_same),
  util.autopair("{", "}", util.char_count_same),
  util.autopair("[", "]", util.char_count_same),
  util.autopair("<", ">", util.char_count_same),
  util.autopair("'", "'", util.even_count),
  util.autopair('"', '"', util.even_count),
  util.autopair("`", "`", util.even_count),
  s({ trig = "date" }, { p(os.date, "%m-%d-%Y") }),
  s({ trig = "time" }, { p(os.date, "%H:%M") }),
}, {
  s({ trig = "#!" }, { d(1, shebang, {}) }),
  s(
    { trig = "{;", wordTrig = false, hidden = true },
    fmt(
      [[
        {{
          {}
        }}
      ]],
      i(1)
    )
  ),
  s({ trig = "lorem" }, c(1, generate_lorem(100))),
}
