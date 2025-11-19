local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local function generate_lorem(words)
  local ret = {}
  for w = 1, words + 1, 1 do
    table.insert(ret, f(function() return vim.fn.systemlist("lorem --lines " .. w) end))
  end
  return ret
end

local function shebang(_, _)
  return sn(nil, { f(function() return rutil.commentstring(1)[1] end), t "!/usr/bin/env ", i(1, vim.bo.filetype) })
end

local function todo_nodes(aliases, opts)
  local alias_nodes = vim.tbl_map(function(alias) return i(nil, alias) end, aliases)
  return fmt("{} {}: {} {}", {
    f(function() return rutil.commentstring(opts.ctype)[1] end),
    c(1, alias_nodes),
    i(2),
    f(function() return rutil.commentstring(opts.ctype)[2] end),
  })
end

local function todo_comment(context, aliases, opts)
  context = context or {}
  if not context.trig then return error("context doesn't include a `trig` key which is mandatory", 2) end
  aliases = type(aliases) == "string" and { aliases } or aliases
  opts = opts or {}
  opts.ctype = opts.ctype or 1
  local alias_string = table.concat(aliases, "|")
  context.name = context.name or (alias_string:upper() .. " comment")
  context.dscr = context.dscr or context.name
  context.docstring = context.docstring or (" {1:" .. alias_string .. "}: {3} <{2:mark}>{0} ")
  local comment_node = todo_nodes(aliases, opts)
  return s(context, comment_node, opts)
end

local user_args = {
  comment = {
    user_args = { { text = " TODO", indent = true, prefix = function() return rutil.commentstring(1)[1] end } },
  },
}

return {
  todo_comment({ trig = "todo" }, "TODO"),
  todo_comment({ trig = "note" }, { "NOTE", "INFO" }),
  todo_comment({ trig = "fix" }, { "FIX", "HACK", "BUG", "ISSUE" }),
  todo_comment({ trig = "warn" }, { "WARN", "WARNING" }),
  todo_comment({ trig = "perf" }, { "PERF", "PERFORMANCE", "OPTIMIZE" }),
  todo_comment({ trig = "btodo" }, "TODO", { ctype = 2 }),
  todo_comment({ trig = "bnote" }, { "NOTE", "INFO" }, { ctype = 2 }),
  todo_comment({ trig = "bfix" }, { "FIX", "HACK", "BUG", "ISSUE" }, { ctype = 2 }),
  todo_comment({ trig = "bwarn" }, { "WARN", "WARNING" }, { ctype = 2 }),
  todo_comment({ trig = "bperf" }, { "PERF", "PERFORMANCE", "OPTIMIZE" }, { ctype = 2 }),
  s({ trig = "date", name = "date", dscr = "Current date" }, { p(os.date, "%m-%d-%Y") }),
  s({ trig = "time", name = "time", dscr = "Current time" }, { p(os.date, "%H:%M") }),
  s({ trig = "lorem", name = "placeholder", dscr = "Placeholder text" }, c(1, generate_lorem(100))),
}, {
  s({ trig = "#!", name = "shebang", dscr = "Script interpreter" }, { d(1, shebang, {}) }),
  s({ trig = "{;", wordTrig = false, hidden = true }, fmt("{{\n{}\n\n", d(1, rutil.saved_text, {}, user_args.comment))),
}
