local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local f = luasnip.function_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local M = {}

M.autopair = function(pair_begin, pair_end, ...)
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

M.char_count_same = function(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 == ct2
end

M.even_count = function(char)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, char, "")
  return ct % 2 == 0
end

M.recursive_case = function()
  return sn(nil, {
    c(1, {
      t "",
      sn(nil, { t { "", "\t\tbreak;", "\tdefault:", "\t\t" }, i(1, "// code") }),
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

M.same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

M.get_last_word = function(index, delim)
  return f(function(args)
    local text = args[1][1] or ""
    local split = vim.split(text, delim, { plain = true })
    return split[#split]
  end, { index })
end

M.get_word_choice = function(args, _, _, delim)
  local text = args[1][1] or ""
  local split = vim.split(text, delim, { plain = true })
  local options = {}
  for len = 0, #split - 1 do
    table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
  end
  return sn(nil, {
    c(1, options),
  })
end

return M
