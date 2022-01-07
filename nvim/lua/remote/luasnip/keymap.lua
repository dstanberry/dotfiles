-- TODO: investigate why this isn't working
--[[ local luasnip = require "remote.luasnip"

vim.keymap.set({ "i", "s" }, "<tab>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return "<tab>"
  end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    return "<s-tab>"
  end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<c-d>", function()
  luasnip.change_choice(1)
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<c-f>", function()
  luasnip.change_choice(-1)
end, { expr = true }) ]]

vim.cmd [[
  imap <silent><expr> <tab> luasnip#expand_or_jumpable() ? '<plug>luasnip-expand-or-jump' : ''
  inoremap <silent> <s-tab> <cmd>lua require('luasnip').jump(-1)<cr>

  snoremap <silent> <tab> <cmd>lua require('luasnip').jump(1)<cr>
  snoremap <silent> <s-tab> <cmd>lua require('luasnip').jump(-1)<cr>

  imap <silent><expr> <c-d> luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<c-d>'
  imap <silent><expr> <c-f> luasnip#choice_active() ? '<plug>luasnip-prev-choice' : '<c-f>'

  smap <silent><expr> <c-d> luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<c-d>'
  smap <silent><expr> <c-f> luasnip#choice_active() ? '<plug>luasnip-prev-choice' : '<c-f>'
]]
