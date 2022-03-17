local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local d = luasnip.dynamic_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node
local p = luasnip.extras.partial
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node

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

local M = {}

M.config = {
  all = {
    util.autopair("(", ")", util.char_count_same),
    util.autopair("{", "}", util.char_count_same),
    util.autopair("[", "]", util.char_count_same),
    util.autopair("<", ">", util.char_count_same),
    util.autopair("'", "'", util.even_count),
    util.autopair('"', '"', util.even_count),
    util.autopair("`", "`", util.even_count),
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
    s({ trig = "date" }, { p(os.date, "%m-%d-%Y") }),
    s({ trig = "#!" }, { d(1, shebang, {}) }),
  },
}

return M
