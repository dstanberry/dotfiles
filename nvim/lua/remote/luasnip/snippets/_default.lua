-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local util = require "remote.luasnip.util"

local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node
local p = require("luasnip.extras").partial

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
    s({ trig = "{;", wordTrig = false, hidden = true }, {
      t { "{", "\t" },
      i(1),
      t { "", "}" },
      i(0),
    }),
    s({ trig = "mdy", name = "Current date", dscr = "Insert the current date" }, {
      p(os.date, "%m-%d-%Y"),
    }),
  },
}

return M
