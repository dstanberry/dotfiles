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

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
  group = "ftplugin",
  callback = function(args) markdown.concealer.toggle_on() end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "BufWritePost" }, {
  group = "ftplugin",
  callback = function() markdown.concealer.disable() end,
})

vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = vim.api.nvim_get_current_buf() })

vim.keymap.set("n", "<c-w><c-a>", markdown.heading.insert_adjacent, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<c-w><c-i>", markdown.heading.insert_inner, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<c-w><c-o>", markdown.heading.insert_outer, { buffer = vim.api.nvim_get_current_buf() })

vim.keymap.set({ "n", "v" }, "<c-w><c-b>", markdown.toggle_bullet, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set({ "n", "v" }, "<c-w><c-c>", markdown.toggle_checkbox, { buffer = vim.api.nvim_get_current_buf() })

vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = vim.api.nvim_get_current_buf() })
