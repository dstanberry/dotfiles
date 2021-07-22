--------------------------------------------------------------
-- => luasnip keymaps
---------------------------------------------------------------
-- ensure luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local util = require "util"

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
  if vim.fn.pumvisible() == 1 then
    return util.t "<c-n>"
  elseif luasnip.expand_or_jumpable() then
    return util.t "<plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return util.t "<tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

-- use s-tab to jump to previous snippet placeholder
local on_s_tab = function()
  if vim.fn.pumvisible() == 1 then
    return util.t "<c-p>"
  elseif luasnip.jumpable(-1) then
    return util.t "<plug>luasnip-jump-prev"
  else
    return util.t "<s-tab>"
  end
end

util.imap("<tab>", on_tab, { expr = true })
util.smap("<tab>", on_tab, { expr = true })
util.imap("<s-tab>", on_s_tab, { expr = true })
util.smap("<s-tab>", on_s_tab, { expr = true })
