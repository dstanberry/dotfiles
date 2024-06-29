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

local md_extmarks = vim.api.nvim_create_augroup("md_extmarks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CmdlineLeave", "InsertLeave" }, {
  group = md_extmarks,
  buffer = 0,
  callback = function()
    if package.loaded["nvim-treesitter"] then markdown.set_extmarks() end
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = md_extmarks,
  buffer = 0,
  callback = function() markdown.disable_extmarks() end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = md_extmarks,
  buffer = 0,
  callback = function() markdown.disable_extmarks(true) end,
})

vim.keymap.set("i", "<s-cr>", markdown.insert_list_marker, { buffer = 0, desc = "insert list marker" })

vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = 0, desc = "insert checkbox" })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = 0, desc = "insert link" })

vim.keymap.set("n", "<c-w><c-a>", markdown.insert_adjacent_heading, { buffer = 0, desc = "insert adjacent heading" })
vim.keymap.set("n", "<c-w><c-i>", markdown.insert_inner_heading, { buffer = 0, desc = "insert inner heading" })
vim.keymap.set("n", "<c-w><c-o>", markdown.insert_outer_heading, { buffer = 0, desc = "insert outer heading" })

vim.keymap.set({ "n", "v" }, "<c-w><c-b>", markdown.toggle_bullet, { buffer = 0, desc = "toggle bullet" })
vim.keymap.set({ "n", "v" }, "<c-w><c-x>", markdown.toggle_checkbox, { buffer = 0, desc = "toggle checkbox" })

-- NOTE: Completion engine will handle this better
-- vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = 0, desc = "zk: insert link to note" })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = 0, desc = "zk: insert link to note" })
