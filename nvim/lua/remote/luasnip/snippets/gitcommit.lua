---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local function make(trigger, name)
  return s(
    { trig = trigger, name = "commit prefix", dscr = "Commit category" },
    fmt(
      "{} {}\n\n{}",
      { c(1, { sn(nil, fmt("{}({}):", { t(name), i(1, "scope") })), t(name .. ":") }), i(2, "title"), i(0) }
    ),
    { condition = conds.line_begin }
  )
end

return {}, {
  make("break", "breaking"),
  make("build", "build"),
  make("chore", "chore"),
  make("ci", "ci"),
  make("docs", "docs"),
  make("feat", "feat"),
  make("fix", "fix"),
  make("perf", "perf"),
  make("ref", "refactor"),
  make("style", "style"),
  make("test", "test"),
}
