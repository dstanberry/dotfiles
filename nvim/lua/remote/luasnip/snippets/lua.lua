local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

return {
  s({
    trig = "ign",
    name = "disable formatting",
    dscr = "Disable `stylua` formatting for the next region",
  }, { t "-- stylua: ignore" }, { condition = conds.line_begin }),
  s(
    { trig = "req", name = "require statement", dscr = "Require statement" },
    fmt([[local {} = require("{}")]], {
      d(2, rutil.repeat_node_segment, { 1 }, { user_args = { "." } }),
      i(1, "mod"),
    })
  ),
  s(
    { trig = "fn", name = "function", dscr = "Declare function" },
    fmt("{}\n{}\nend", {
      c(1, {
        fmt("function({})", { r(1, "params") }),
        fmt("function {}({})", { r(1, "name"), r(2, "params") }),
        fmt("local {} = function({})", { r(1, "name"), r(2, "params") }),
        fmt("local function {}({})", { r(1, "name"), r(2, "params") }),
      }),
      d(2, rutil.saved_text, {}, { user_args = { { text = "-- TODO", indent = true } } }),
    }),
    {
      stored = {
        ["name"] = i(nil, "func"),
        ["params"] = i(nil, "..."),
      },
    }
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
    { trig = "ok", name = "require check", dscr = "Check if import was successful" },
    fmt('local {}, {} = pcall(require,"{}")\nif not {} then\n\treturn\nend', {
      i(1, "ok"),
      d(3, rutil.repeat_node_segment, { 2 }, { user_args = { "." } }),
      i(2, "mod"),
      rutil.repeat_node(1),
    })
  ),
  ts_postfix(
    {
      trig = ".pair",
      name = "for loop |(i)pairs|",
      dscr = "For loop (treesitter postfix)",
      wordTrig = false,
      reparseBuffer = "live",
      matchTSNode = ts_postfix_builtin.tsnode_matcher.find_topmost_types {
        "function_call",
        "identifier",
        "expression_list",
        "dot_index_expression",
        "bracket_index_expression",
      },
    },
    fmt("for k, v in {}({}) do\n\t{}\nend", {
      c(1, { t "pairs", t "ipairs" }),
      l(l.LS_TSMATCH),
      i(0),
    })
  ),
}, {
  s(
    { trig = "[[-", wordTrig = false, hidden = true, name = "multi-line comment", dscr = "Multi-line comment" },
    fmt("--[[\n\t{}\n]]", i(1))
  ),
  s(
    { trig = "[[;", wordTrig = false, hidden = true, name = "multiline string", dscr = "Multi-line string" },
    fmt("[[\n\t{}\n]]", i(1))
  ),
}
