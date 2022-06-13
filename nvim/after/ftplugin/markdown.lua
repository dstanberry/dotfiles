local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local markdown = require "ft.markdown"

vim.opt_local.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
vim.opt_local.iskeyword:append "-"
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "min:5,list:-1"
vim.opt_local.concealcursor = "c"
vim.opt_local.conceallevel = 2
-- vim.opt_local.spell = true
vim.opt_local.wrap = true

vim.keymap.set("i", "<c-w>c", markdown.insert_checkbox, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("i", "<c-w>p", markdown.insert_link, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set({ "n", "v" }, "<c-a>b", markdown.toggle_bullet, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set({ "n", "v" }, "<c-a>c", markdown.toggle_checkbox, { buffer = vim.api.nvim_get_current_buf() })

groups.new("CodeBlock", { bg = c.bg_dark })

vim.fn.sign_define("codeblock", {
  linehl = "CodeBlock",
})

markdown.highlight_fenced_code_blocks()
