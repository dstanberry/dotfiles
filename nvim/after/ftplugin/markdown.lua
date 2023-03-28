local markdown = require "ft.markdown"

vim.opt_local.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
vim.opt_local.iskeyword:append "-"
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "min:5,list:-1"
vim.opt_local.concealcursor = "c"
vim.opt_local.conceallevel = 2
-- vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.colorcolumn = "80"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = "ftplugin",
  buffer = 0,
  callback = function() markdown.concealer.toggle_on() end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "ftplugin",
  buffer = 0,
  callback = function() markdown.concealer.disable() end,
})

vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = 0, desc = "insert checkbox" })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = 0, desc = "insert link" })

vim.keymap.set("n", "<c-w><c-a>", markdown.heading.insert_adjacent, { buffer = 0, desc = "insert adjacent heading" })
vim.keymap.set("n", "<c-w><c-i>", markdown.heading.insert_inner, { buffer = 0, desc = "insert inner heading" })
vim.keymap.set("n", "<c-w><c-o>", markdown.heading.insert_outer, { buffer = 0, desc = "insert outer heading" })

vim.keymap.set({ "n", "v" }, "<c-w><c-b>", markdown.toggle_bullet, { buffer = 0, desc = "toggle bullet" })
vim.keymap.set({ "n", "v" }, "<c-w><c-x>", markdown.toggle_checkbox, { buffer = 0, desc = "toggle checkbox" })

vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = 0, desc = "zk: insert link to note" })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = 0, desc = "zk: insert link to note" })
