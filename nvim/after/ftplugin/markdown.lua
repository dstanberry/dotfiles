local markdown = require "ft.markdown"

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

vim.bo.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
vim.bo.iskeyword = vim.bo.iskeyword .. ",@-@"
vim.wo.breakindent = true
vim.wo.breakindentopt = "min:5,list:-1"
vim.wo.concealcursor = "c"
vim.wo.conceallevel = 2
-- vim.wo.spell = true
vim.wo.wrap = true

vim.keymap.set("i", "<c-w>c", markdown.insert_checkbox, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("i", "<c-w>p", markdown.insert_link, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set({ "n", "v" }, "<c-a>b", markdown.toggle_bullet, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set({ "n", "v" }, "<c-a>c", markdown.toggle_checkbox, { buffer = vim.api.nvim_get_current_buf() })

vim.api.nvim_create_augroup("filetype_markdown", { clear = true })

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = "filetype_markdown",
  pattern = { "*.md", "*.mdx" },
  callback = function()
    markdown.highlight_fenced_code_blocks()
  end,
})

groups.new("CodeBlock", { guifg = nil, guibg = c.baseXX, gui = "none", guisp = nil })

vim.fn.sign_define("codeblock", {
  linehl = "CodeBlock",
})

markdown.highlight_fenced_code_blocks()
