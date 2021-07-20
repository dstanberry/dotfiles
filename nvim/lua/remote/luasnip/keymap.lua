--------------------------------------------------------------
-- => luasnip keymaps
---------------------------------------------------------------
-- ensure luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local util = require "util"

-- use tab to jump to next snippet placeholder
local on_tab = function()
  return luasnip.jump(1) and "" or util.t("<tab>")
end

-- use s-tab to jump to previous snippet placeholder
local on_s_tab = function()
  return luasnip.jump(-1) and "" or util.t("<s-tab>")
end

util.imap("<tab>", on_tab, { expr = true })
util.smap("<tab>", on_tab, { expr = true })
util.imap("<s-tab>", on_s_tab, { expr = true })
util.smap("<s-tab>", on_s_tab, { expr = true })
