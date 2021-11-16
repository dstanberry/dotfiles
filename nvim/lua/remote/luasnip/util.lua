-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local M = {}

local s = luasnip.snippet
local f = luasnip.function_node
local i = luasnip.insert_node
local t = luasnip.text_node

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

M.same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

return M
