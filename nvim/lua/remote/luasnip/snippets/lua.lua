local rutil = require("remote.luasnip.util")

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

return {
  s({ trig = "ig[nore]", regTrig = true }, { t "-- stylua: ignore" }),
  s(
    { trig = "re[quire]", regTrig = true },
    fmt([[local {} = require("{}")]], {
      d(2, rutil.repeat_node_segment, { 1 }, { user_args = { "." } }),
      i(1, "mod"),
    })
  ),
  s(
    { trig = "fn" },
    fmt("{}\n{}\nend", {
      c(1, {
        sn(nil, fmt("function({})", { i(1) })),
        sn(nil, fmt("local function {}({})", { i(1), i(2) })),
        sn(nil, fmt("local {} = function({})", { i(1), i(2) })),
      }),
      d(2, rutil.saved_text, {}, { user_args = { { indent = true } } }),
    })
  ),
  s(
    { trig = "for" },
    fmt("for {} do\n{}\nend", {
      c(1, {
        sn(
          nil,
          fmt("{}, {} in {}({})", {
            i(1, "k"),
            i(2, "v"),
            c(3, { t "pairs", t "ipairs" }),
            i(4, "table"),
          })
        ),
        sn(
          nil,
          fmt("{} = {}, {}", {
            i(1, "i"),
            i(2, "v"),
            i(3, "bound"),
          })
        ),
        sn(
          nil,
          fmt("{} = {}, {}, {}", {
            i(1, "i"),
            i(2, "value"),
            i(3, "bound"),
            i(4, "direction"),
          })
        ),
      }),
      d(2, rutil.saved_text, {}, { user_args = { { indent = true } } }),
    })
  ),
  s(
    { trig = "if" },
    fmt("if {} then\n{}\nend", {
      i(1, "expr"),
      d(2, rutil.saved_text, {}, { user_args = { { indent = true } } }),
    })
  ),
  s(
    { trig = "ok" },
    fmt('local {}, {} = pcall(require,"{}")\nif not {} then\n\treturn\nend', {
      i(1, "ok"),
      d(3, rutil.repeat_node_segment, { 2 }, { user_args = { "." } }),
      i(2, "mod"),
      rutil.repeat_node(1),
    })
  ),
}, {
  s({ trig = "[[-", wordTrig = false, hidden = true }, fmt("--[[\n\t{}\n]]", i(1))),
  s({ trig = "[[;", wordTrig = false, hidden = true }, fmt("[[\n\t{}\n]]", i(1))),
}
