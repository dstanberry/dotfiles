-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local map = require "util.map"

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

local on_tab = function()
  if luasnip.expand_or_jumpable() then
    return luasnip.expand_or_jump()
  elseif check_back_space() then
    return map.t "<tab>"
  end
end

local on_s_tab = function()
  if luasnip.jumpable(-1) then
    return luasnip.jump(-1)
  else
    return map.t "<s-tab>"
  end
end

local function next_choice()
  return luasnip.change_choice(1)
end

local function prev_choice()
  return luasnip.change_choice(-1)
end

map.imap("<tab>", on_tab)
map.smap("<tab>", on_tab)
map.imap("<s-tab>", on_s_tab)
map.smap("<s-tab>", on_s_tab)
map.imap("<c-d>", next_choice)
map.smap("<c-d>", next_choice)
map.imap("<c-f>", prev_choice)
map.smap("<c-f>", prev_choice)
