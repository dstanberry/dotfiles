local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local c = luasnip.choice_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local fmt = luasnip.extras_fmt.fmt

local function make(trig, name)
  return s(
    trig,
    fmt("{} {}\n\n{}", {
      c(1, {
        sn(nil, fmt("{}({}):", { t(name), i(1, "scope") })),
        t(name .. ":"),
      }),
      i(2, "title"),
      i(0),
    })
  )
end

return {
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
