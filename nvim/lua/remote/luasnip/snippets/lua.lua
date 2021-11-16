-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local s = luasnip.snippet
local choice = luasnip.choice_node
local ins = luasnip.insert_node
local snip = luasnip.snippet_node
local txt = luasnip.text_node

local M = {}

M.config = {
  lua = {
    s({ trig = "[[-", wordTrig = false, hidden = true }, {
      txt "--[[",
      txt { "", "\t" },
      ins(0),
      txt { "", "--]]" },
    }),
    s({ trig = "[[;", wordTrig = false, hidden = true }, {
      txt "[[",
      txt { "", "\t" },
      ins(0),
      txt { "", "]]" },
    }),
    s({ trig = "ig", wordTrig = true, hidden = true }, {
      txt "-- stylua: ignore",
    }),
    s({ trig = "fn", wordTrig = true, dscr = "function(param) .. end" }, {
      txt "function(",
      ins(1, "_"),
      txt { ")", "\t" },
      ins(0),
      txt { "", "end" },
    }),
    s({ trig = "lf", wordTrig = true, dscr = "local function f(param) .. end" }, {
      txt "local function ",
      ins(1, "f"),
      txt "(",
      ins(2, "_"),
      txt ")",
      txt { "", "\t" },
      ins(0),
      txt { "", "end" },
    }),
    s({ trig = "tf", wordTrig = true, dscr = "local f = function(param) .. end" }, {
      txt "local ",
      ins(1, "f"),
      txt " = function(",
      ins(2, "_"),
      txt ")",
      txt { "", "\t" },
      ins(0),
      txt { "", "end" },
    }),
    s({ trig = "if", wordTrig = true }, {
      txt "if ",
      ins(1),
      txt { " then", "\t" },
      ins(0),
      txt { "", "end" },
    }),
    s({ trig = "lt", wordTrig = true, dscr = "local var = { .. }" }, {
      txt "local ",
      ins(1, "var"),
      txt " = {",
      txt { "", "\t" },
      ins(0),
      txt { "", "}" },
    }),
    s("for", {
      txt "for ",
      choice(1, {
        snip(nil, {
          ins(1, "k"),
          txt ", ",
          ins(2, "v"),
          txt " in ",
          choice(3, { txt "pairs", txt "ipairs" }),
          txt "(",
          ins(4),
          txt ")",
        }),
        snip(nil, { ins(1, "i"), txt " = ", ins(2), txt ", ", ins(3) }),
      }),
      txt { " do", "\t" },
      ins(0),
      txt { "", "end" },
    }),
  },
}

return M
