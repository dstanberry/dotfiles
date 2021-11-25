local luasnip = require "remote.luasnip"
local map = require "util.map"

local expand_or_jump = function()
  if luasnip.expand_or_jumpable() then
    return map.t "<plug>luasnip-expand-or-jump"
  end
  return map.t "<c-right>"
end

local jump_prev = function()
  if luasnip.jumpable(-1) then
    return map.t "<plug>luasnip-jump-prev"
  end
  return map.t "<c-left>"
end

local function next_choice()
  return luasnip.change_choice(1)
end

local function prev_choice()
  return luasnip.change_choice(-1)
end

map.imap("<c-right>", expand_or_jump, { expr = true })
map.smap("<c-right>", expand_or_jump, { expr = true })
map.imap("<c-left>", jump_prev, { expr = true })
map.smap("<c-left>", jump_prev, { expr = true })
map.imap("<c-d>", next_choice)
map.smap("<c-d>", next_choice)
map.imap("<c-f>", prev_choice)
map.smap("<c-f>", prev_choice)
