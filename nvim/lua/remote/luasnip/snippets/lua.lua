local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt
local fmta = luasnip.extras_fmt.fmta
-- local l = luasnip.extras.lambda

local M = {}

M.config = {
  lua = {
    s({ trig = "ig[nore]", regTrig = true, wordTrig = true, hidden = true }, { t "-- stylua: ignore" }),
    s(
      { trig = "req[uire]", regTrig = true },
      fmt([[local {} = require("{}")]], { d(2, util.get_word_choice, { 1 }, { user_args = { "." } }), i(1, "mod") })
    ),
    s(
      { trig = "[[-", wordTrig = false, hidden = true },
      fmt(
        [=[
          --[[
            {}
          --]]
        ]=],
        i(1)
      )
    ),
    s(
      { trig = "[[;", wordTrig = false, hidden = true },
      fmt(
        [=[
          [[
            {}
          ]]
        ]=],
        i(1)
      )
    ),
    s(
      { trig = "fn", dscr = "function(param) .. end" },
      fmt(
        [[
          function({1})
            {}
          end
        ]],
        {
          i(1),
          i(2),
        }
      )
    ),
    s(
      { trig = "lf", dscr = "local function f(param) .. end" },
      fmt(
        [[
          local function {1}({2})
            {}
          end
        ]],
        {
          i(1, "func"),
          i(2),
          i(3),
        }
      )
    ),
    s(
      { trig = "tf", dscr = "local f = function(param) .. end" },
      fmt(
        [[
          local {1} = function({2})
            {}
          end
        ]],
        {
          i(1, "var"),
          i(2),
          i(3),
        }
      )
    ),
    s(
      { trig = "if" },
      fmt(
        [[
          if {1} then
            {}
          end
        ]],
        {
          i(1, "expr"),
          i(2),
        }
      )
    ),
    s(
      { trig = "lt", dscr = "local var = { .. }" },
      fmta(
        [[
          local <1> = {
            <>
          }
        ]],
        {
          i(1, "var"),
          i(2),
        }
      )
    ),
    s(
      "for",
      fmt(
        [[
          for {} do
            {}
          end
        ]],
        {
          c(1, {
            sn(
              nil,
              fmt([[{}, {} in {}()]], {
                i(1, "k"),
                i(2, "v"),
                c(3, { t "pairs", t "ipairs" }),
              })
            ),
            sn(
              nil,
              fmt([[{} = {}, {}]], {
                i(1, "i"),
                i(2, "v"),
                i(3, "bound"),
              })
            ),
            sn(
              nil,
              fmt([[{} = {}, {}, {}]], {
                i(1, "i"),
                i(2, "v"),
                i(3, "bound"),
                i(4, "direction"),
              })
            ),
          }),
          i(2),
        }
      )
    ),
    s(
      "ok",
      fmt(
        [[
          local {}, {} = pcall(require,"{}")
          if not {} then
            return
          end
        ]],
        {
          i(1, "ok"),
          d(3, util.get_word_choice, { 2 }, { user_args = { "." } }),
          i(2, "mod"),
          util.same(1),
        }
      )
    ),
  },
}

return M
