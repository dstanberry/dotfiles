-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local map = require "util.map"

local on_tab = function()
  if luasnip.expand_or_jumpable() then
    return map.t "<plug>luasnip-expand-or-jump"
  end
  return map.t "<tab>"
end

local on_s_tab = function()
  if luasnip.jumpable(-1) then
    return map.t "<plug>luasnip-jump-prev"
  end
  return map.t "<s-tab>"
end

local function next_choice()
  return luasnip.change_choice(1)
end

local function prev_choice()
  return luasnip.change_choice(-1)
end

map.imap("<tab>", on_tab, { expr = true })
map.smap("<tab>", on_tab, { expr = true })
map.imap("<s-tab>", on_s_tab, { expr = true })
map.smap("<s-tab>", on_s_tab, { expr = true })
map.imap("<c-d>", next_choice)
map.smap("<c-d>", next_choice)
map.imap("<c-f>", prev_choice)
map.smap("<c-f>", prev_choice)
