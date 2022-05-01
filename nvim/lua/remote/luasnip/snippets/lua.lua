local luasnip = require "remote.luasnip"
local util = require "remote.luasnip.util"

local c = luasnip.choice_node
local d = luasnip.dynamic_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt
-- local l = luasnip.extras.lambda

return {
  s({ trig = "ig[nore]", regTrig = true, wordTrig = true, hidden = true }, { t "-- stylua: ignore" }),
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
    { trig = "req[uire]", regTrig = true },
    fmt([[local {} = require("{}")]], {
      d(2, util.repeat_word, { 1 }, { user_args = { "." } }),
      i(1, "mod"),
    })
  ),
  s(
    { trig = "fn" },
    fmt(
      [[
        {}
          {}
        end
      ]],
      {
        c(1, {
          sn(nil, fmt([[function({})]], { i(1) })),
          sn(nil, fmt([[local function {}({})]], { i(1), i(2) })),
          sn(nil, fmt([[local {} = function({})]], { i(1), i(2) })),
        }),
        d(2, util.saved_text, {}, { user_args = { { indent = true } } }),
      }
    )
  ),
  s(
    { trig = "if" },
    fmt(
      [[
        if {} then
          {}
        end
      ]],
      {
        i(1, "expr"),
        d(2, util.saved_text, {}, { user_args = { { indent = true } } }),
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
              i(2, "value"),
              i(3, "bound"),
              i(4, "direction"),
            })
          ),
        }),
        d(2, util.saved_text, {}, { user_args = { { indent = true } } }),
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
        d(3, util.repeat_word, { 2 }, { user_args = { "." } }),
        i(2, "mod"),
        util.mimic(1),
      }
    )
  ),
}
