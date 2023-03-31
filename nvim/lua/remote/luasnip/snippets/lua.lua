local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

return {
  s({
    trig = "ig[nore]",
    regTrig = true,
    name = "disable formatting",
    dscr = "Disable `stylua` formatting for the next region",
  }, { t "-- stylua: ignore" }),
  s(
    { trig = "re[quire]", regTrig = true, name = "require statement", dscr = "Require statement" },
    fmt([[local {} = require("{}")]], {
      d(2, rutil.repeat_node_segment, { 1 }, { user_args = { "." } }),
      i(1, "mod"),
    })
  ),
  s(
    { trig = "fn", name = "function", dscr = "Declare function" },
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
    { trig = "for", name = "for loop", dscr = "For loop (dynamic)" },
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
    { trig = "if", name = "if statement", dscr = "If statement" },
    fmt("if {} then\n{}\nend", {
      i(1, "expr"),
      d(2, rutil.saved_text, {}, { user_args = { { indent = true } } }),
    })
  ),
  s(
    { trig = "ok", name = "require check", dscr = "Check error after `|require(...)|` call" },
    fmt('local {}, {} = pcall(require,"{}")\nif not {} then\n\treturn\nend', {
      i(1, "ok"),
      d(3, rutil.repeat_node_segment, { 2 }, { user_args = { "." } }),
      i(2, "mod"),
      rutil.repeat_node(1),
    })
  ),
}, {
  s({ trig = "[[-", wordTrig = false, hidden = true, name = "multi-line comment", dscr = "Multi-line comment" }, fmt("--[[\n\t{}\n]]", i(1))),
  s({ trig = "[[;", wordTrig = false, hidden = true, name = "multiline string", dscr = "Multi-line string" }, fmt("[[\n\t{}\n]]", i(1))),
}
