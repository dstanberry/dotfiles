local util = require "util"
local markdown = require "custom.markdown"

local color = require "util.color"
local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

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
        markdown.highlight_blocks()
        vim.wo.conceallevel = 2
        vim.wo.concealcursor = "c"
        vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
        vim.bo.iskeyword = vim.bo.iskeyword .. ",@-@"
        vim.wo.wrap = true
        vim.wo.breakindent = true
        vim.wo.breakindentopt = "min:5,list:-1"
        vim.bo.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
      end,
    },
  },
}

c.lang00 = color.darken(c.base00, 15)
groups.new("CodeBlock", { guifg = nil, guibg = c.lang00, gui = "none", guisp = nil })

vim.fn.sign_define("codeblock", {
  linehl = "CodeBlock",
})
