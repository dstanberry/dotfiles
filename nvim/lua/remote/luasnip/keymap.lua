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

-- use tab to jump to next snippet placeholder
local on_tab = function()
  if luasnip.expand_or_jumpable() then
    return map.t "<plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return map.t "<tab>"
  else
    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
      return cmp.mapping.complete()
    end
  end
end

-- use s-tab to jump to previous snippet placeholder
local on_s_tab = function()
  if luasnip.jumpable(-1) then
    return map.t "<plug>luasnip-jump-prev"
  else
    return map.t "<s-tab>"
  end
end

local next_choice = function()
  if luasnip.choice_active then
    return map.t "<plug>luasnip-next-choice"
  else
    return map.t ""
  end
end

local prev_choice = function()
  if luasnip.choice_active then
    return map.t "<plug>luasnip-prev-choice"
  else
    return map.t ""
  end
end

map.imap("<tab>", on_tab, { expr = true })
map.smap("<tab>", on_tab, { expr = true })
map.imap("<s-tab>", on_s_tab, { expr = true })
map.smap("<s-tab>", on_s_tab, { expr = true })
map.imap("<c-e>", next_choice, { expr = true })
map.smap("<c-e>", next_choice, { expr = true })
map.imap("<c-t>", prev_choice, { expr = true })
map.smap("<c-t>", prev_choice, { expr = true })
