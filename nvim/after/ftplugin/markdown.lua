local util = require "util"

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

util.define_augroup {
  name = "filetype_markdown",
  autocmds = {
    {
      event = "BufEnter",
      pattern = { "*.md", "*.mdx" },
      command = "syntax sync fromstart",
    },
    {
      event = { "BufEnter", "TextChanged", "TextChangedI" },
      pattern = { "*.md", "*.mdx" },
      callback = function()
        markdown.highlight_fenced_code_blocks()
      end,
    },
  },
}

groups.new("CodeBlock", { guifg = nil, guibg = c.baseXX, gui = "none", guisp = nil })

vim.fn.sign_define("codeblock", {
  linehl = "CodeBlock",
})
