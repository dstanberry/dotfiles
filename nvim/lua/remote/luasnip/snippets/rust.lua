local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

return {
  s(
    { trig = "enum", name = "enum", dscr = "Declare enum" },
    fmt("#[derive({})]\nenum {} {{\n\t{}\n}}", {
      c(1, {
        sn(nil, fmt("{}", { i(1) })),
        sn(nil, fmt("{}, {}", { i(1, "Debug"), i(2, "PartialEq") })),
        sn(nil, fmt("{}, {}, {}", { i(1, "Debug"), i(2, "PartialEq"), i(3, "Clone") })),
      }),
      i(2, "Name"),
      i(3),
    })
  ),
  s(
    { trig = "eq", name = "assert equality", dscr = "Assert equality" },
    fmt("assert_eq!({}, {});{}", { i(1), i(2), i(3) })
  ),
  s(
    { trig = "fn", name = "function", dscr = "Declare function" },
    fmt("function {}({}) {{\n{}\n}}", {
      i(1, "main"),
      i(2, ""),
      d(3, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "for", name = "for loop", dscr = "For loop" },
    fmt("for {} in {} {{\n{}\n}}", {
      i(1, "i"),
      i(2, "iterator"),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "modtest", name = "test module", dscr = "Test module" },
    fmt("#[cfg(test)]\nmod test {{\n\tuse super::*;\n\t{}\n}}", i(1))
  ),
  s(
    { trig = "struct", name = "struct", dscr = "Declare struct" },
    fmt("#[derive({})]\nstruct {} {{\n\t{}\n}}", {
      c(1, {
        sn(nil, fmt("{}", { i(1) })),
        sn(nil, fmt("{}, {}", { i(1, "Debug"), i(2, "PartialEq") })),
        sn(nil, fmt("{}, {}, {}", { i(1, "Debug"), i(2, "PartialEq"), i(3, "Clone") })),
      }),
      i(2, "Name"),
      i(3),
    })
  ),
  s(
    { trig = "test", name = "test", dscr = "Add test" },
    fmt("#[test]\nfn {}(){}{{\n\t{}\n}}", {
      i(1, "testname"),
      c(2, { t "", t " -> Result<()> " }),
      i(3),
    })
  ),
}, {
  s(
    { trig = "print[ln]", name = "log", dscr = "Print to stdout" },
    fmt([[println!("{}: {{:?}}", {});]], { rep(1), i(1) }),
    {
      condition = conds.line_begin,
    }
  ),
}
