-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local rutil = require("remote.luasnip.util")

vim.keymap.set({ "i", "s" }, "<tab>", function()
  if luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<tab>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
  if luasnip.in_snippet() and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<s-tab>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-d>", function()
  if luasnip.in_snippet() and luasnip.choice_active() then
    luasnip.change_choice(1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-d>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-f>", function()
  if luasnip.in_snippet() and luasnip.choice_active() then
    luasnip.change_choice(-1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-d>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-t>", function()
  rutil.dynamic_node_external_update(1)
end, { silent = true })
