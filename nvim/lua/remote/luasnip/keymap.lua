local luasnip = require "remote.luasnip"

vim.keymap.set({ "i", "s" }, "<tab>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<tab>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<s-tab>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-d>", function()
  luasnip.change_choice(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-f>", function()
  luasnip.change_choice(-1)
end, { silent = true })
