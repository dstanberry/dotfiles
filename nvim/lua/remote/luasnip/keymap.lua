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

local on_s_tab = function()
  if luasnip.jumpable(-1) then
    return map.t "<plug>luasnip-jump-prev"
  else
    return map.t "<s-tab>"
  end
end

map.imap("<tab>", on_tab, { expr = true })
map.smap("<tab>", on_tab, { expr = true })
map.imap("<s-tab>", on_s_tab, { expr = true })
map.smap("<s-tab>", on_s_tab, { expr = true })
map.imap("<c-d>", "<plug>luasnip-next-choice")
map.smap("<c-d>", "<plug>luasnip-next-choice")
map.imap("<c-f>", "<plug>luasnip-prev-choice")
map.smap("<c-f>", "<plug>luasnip-prev-choice")
