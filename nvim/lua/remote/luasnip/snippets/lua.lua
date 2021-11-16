-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local util = require "remote.luasnip.util"

local s = luasnip.snippet
local c = luasnip.choice_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local M = {}

M.config = {
  lua = {
    s({ trig = "[[-", wordTrig = false, hidden = true }, {
      t "--[[",
      t { "", "\t" },
      i(0),
      t { "", "--]]" },
    }),
    s({ trig = "[[;", wordTrig = false, hidden = true }, {
      t "[[",
      t { "", "\t" },
      i(0),
      t { "", "]]" },
    }),
    s({ trig = "ig", wordTrig = true, hidden = true }, {
      t "-- stylua: ignore",
    }),
    s({ trig = "fn", wordTrig = true, dscr = "function(param) .. end" }, {
      t "function(",
      i(1, "_"),
      t { ")", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "lf", wordTrig = true, dscr = "local function f(param) .. end" }, {
      t "local function ",
      i(1, "f"),
      t "(",
      i(2, "_"),
      t ")",
      t { "", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "tf", wordTrig = true, dscr = "local f = function(param) .. end" }, {
      t "local ",
      i(1, "f"),
      t " = function(",
      i(2, "_"),
      t ")",
      t { "", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "if", wordTrig = true }, {
      t "if ",
      i(1),
      t { " then", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "lt", wordTrig = true, dscr = "local var = { .. }" }, {
      t "local ",
      i(1, "var"),
      t " = {",
      t { "", "\t" },
      i(0),
      t { "", "}" },
    }),
    s("for", {
      t "for ",
      c(1, {
        sn(nil, {
          i(1, "k"),
          t ", ",
          i(2, "v"),
          t " in ",
          c(3, { t "pairs", t "ipairs" }),
          t "(",
          i(4),
          t ")",
        }),
        sn(nil, { i(1, "i"), t " = ", i(2), t ", ", i(3) }),
      }),
      t { " do", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "ok", wordTrig = true }, {
      t "local ",
      i(1, "ok"),
      t ", ",
      i(2, "mod"),
      t [[ = pcall(require, "]],
      util.same(2),
      t [[")]],
      t { "", "if not " },
      util.same(1),
      t { " then", "\treturn" },
      t { "", "end" },
    }),
  },
}

return M
