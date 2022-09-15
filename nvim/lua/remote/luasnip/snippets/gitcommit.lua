---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

local function make(trigger, name)
  return s(
    { trig = trigger },
    fmt("{} {}\n{}", {
      c(1, {
        sn(nil, fmt("{}({}):", { t(name), i(1, "scope") })),
        t(name .. ":"),
      }),
      i(2, "title"),
      i(0),
    }),
    {
      condition = conds.line_begin,
    }
  )
end

return {}, {
  make("build", "build"),
  make("chore", "chore"),
  make("feat", "feat"),
  make("fix", "fix"),
  make("docs", "docs"),
  make("ref", "refactor"),
  make("perf", "perf"),
  make("style", "style"),
  make("test", "test"),
}
