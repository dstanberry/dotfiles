local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local f = luasnip.function_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local M = {}

M.autopair = {}

M.autopair.create = function(pair_begin, pair_end, ...)
  local function negate(fn, ...)
    return not fn(...)
  end
  local function part(func, ...)
    local args = { ... }
    return function()
      return func(unpack(args))
    end
  end
  return s(
    { trig = pair_begin, wordTrig = false, hidden = true },
    { t { pair_begin }, i(1), t { pair_end } },
    { condition = part(negate, part(..., pair_begin, pair_end)) }
  )
end

M.autopair.punctuation_matched = function(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 == ct2
end

M.autopair.char_matched = function(char)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, char, "")
  return ct % 2 == 0
end

M.mimic = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

M.recursive_case = function()
  return sn(nil, {
    c(1, {
      t "",
      sn(nil, {
        t { "", "\t\tbreak;", "\tdefault:", "\t\t" },
        i(1, "// code"),
      }),
      sn(nil, {
        t { "", "\t\tbreak;", "\tcase " },
        i(1, "value"),
        t { ":", "\t\t" },
        i(2, "// code"),
        d(3, M.recursive_case, {}),
      }),
    }),
  })
end

M.recursive_if = function()
  return sn(nil, {
    c(1, {
      t "",
      sn(nil, {
        t { "", "} else {", "\t" },
        i(1, "// code"),
      }),
      sn(nil, {
        t { "", "} elseif (" },
        i(1, "expr"),
        t { ") {", "\t" },
        i(2, "// code"),
        d(3, M.recursive_if, {}),
      }),
    }),
  })
end

M.repeat_word = function(args, _, _, delim, ext)
  local text = args[1][1] or ""
  if ext then
    local stripped = text:match "(.+)%..+$"
    if stripped then
      text = stripped
    end
  end
  local split = vim.split(text, delim, { plain = true })
  local options = {}
  for len = 0, #split - 1 do
    table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
  end
  return sn(nil, {
    c(1, options),
  })
end

M.saved_text = function(_, snip, old_state, user_args)
  local nodes = {}
  old_state = old_state or {}
  user_args = user_args or {}

  local indent = user_args.indent and "\t" or ""

  if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
    local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
    for idx = 1, #lines do
      local line = indent .. lines[idx]
      local node = idx == #lines and { line } or { line, "" }
      table.insert(nodes, t(node))
    end
  else
    local text = user_args.text or M.get_comment "code"
    if indent ~= "" then
      table.insert(nodes, t(indent))
    end
    table.insert(nodes, i(1, text))
  end

  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

return M
