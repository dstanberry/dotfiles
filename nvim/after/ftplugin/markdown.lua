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

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CmdlineLeave", "InsertLeave" }, {
  group = "ftplugin",
  buffer = true,
  callback = function() markdown.concealer.toggle_on() end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "ftplugin",
  buffer = true,
  callback = function() markdown.concealer.disable() end,
})

vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = true, desc = "insert checkbox" })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = true, desc = "insert link" })

vim.keymap.set("n", "<c-w><c-a>", markdown.heading.insert_adjacent, { buffer = true, desc = "insert adjacent heading" })
vim.keymap.set("n", "<c-w><c-i>", markdown.heading.insert_inner, { buffer = true, desc = "insert inner heading" })
vim.keymap.set("n", "<c-w><c-o>", markdown.heading.insert_outer, { buffer = true, desc = "insert outer heading" })

vim.keymap.set({ "n", "v" }, "<c-w><c-b>", markdown.toggle_bullet, { buffer = true, desc = "toggle bullet" })
vim.keymap.set({ "n", "v" }, "<c-w><c-x>", markdown.toggle_checkbox, { buffer = true, desc = "toggle checkbox" })

vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = true, desc = "zk: insert link to note" })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = true, desc = "zk: insert link to note" })
