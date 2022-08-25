local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

return {
  s({ trig = "enum" }, fmt("#[derive(Debug, PartialEq)]\nenum {} {{\n\t{}\n}}", { i(1, "Name"), i(2) })),
  s({ trig = "eq" }, fmt("assert_eq!({}, {});{}", { i(1), i(2), i(3) })),
  s(
    { trig = "fn" },
    fmt("function {}({}) {{\n{}\n}}", {
      i(1, "main"),
      i(2, ""),
      d(3, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
    })
  ),
  s(
    { trig = "for" },
    fmt("for {} in {} {{\n{}\n}}", {
      i(1, "i"),
      i(2, "iterator"),
      d(3, rutil.saved_text, {}, { user_args = { { text = "# TODO", indent = true } } }),
    })
  ),
  s({ trig = "modtest" }, fmt("#[cfg(test)]\nmod test {{\n\tuse super::*;\n\t{}\n}}", i(1))),
  s({ trig = "struct" }, fmt("#[derive(Debug, PartialEq)]\nstruct {} {{\n\t{}\n}}", { i(1, "Name"), i(2) })),
  s(
    { trig = "test" },
    fmt("#[test]\nfn {}(){}{{\n\t{}\n}}", {
      i(1, "testname"),
      c(2, { t "", t " -> Result<()> " }),
      i(3),
    })
  ),
}, {
  s({ trig = "print[ln]", regTrig = true }, fmt([[println!("{}: {{:?}}", {});]], { rep(1), i(1) })),
}
