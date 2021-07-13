--------------------------------------------------------------
-- => luasnip keymaps
---------------------------------------------------------------
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

-- utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

-- Use tab to:
--- move to next item in completion menu
--- jump to next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<c-n>"
  elseif luasnip.expand_or_jumpable() then
    return t "<plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return t "<tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

-- Use (s-)tab to:
--- move to prev item in completion menu
--- jump to prev snippet's placeholder
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<c-p>"
  elseif luasnip.jumpable(-1) then
    return t "<plug>luasnip-jump-prev"
  else
    return t "<s-tab>"
  end
end

-- map tab to the above tab complete functions
local opts = { expr = true }

vim.api.nvim_set_keymap("i", "<tab>", "v:lua.tab_complete()", opts)
vim.api.nvim_set_keymap("s", "<tab>", "v:lua.tab_complete()", opts)
vim.api.nvim_set_keymap("i", "<s-tab>", "v:lua.s_tab_complete()", opts)
vim.api.nvim_set_keymap("s", "<s-tab>", "v:lua.s_tab_complete()", opts)
