local util = require "util"
local inoremap = util.map.inoremap
local nnoremap = util.map.nnoremap
local vnoremap = util.map.vnoremap

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
        markdown.highlight_fenced_code_blocks()
        vim.wo.conceallevel = 2
        vim.wo.concealcursor = "c"
        vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
        vim.bo.iskeyword = vim.bo.iskeyword .. ",@-@"
        vim.wo.wrap = true
        vim.wo.breakindent = true
        vim.wo.breakindentopt = "min:5,list:-1"
        vim.bo.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
        nnoremap("<leader>mm", function()
          markdown.create_note()
        end)
        nnoremap("<leader>mr", function()
          markdown.create_template_reference()
        end)
        inoremap("<c-w>c", function()
          markdown.insert_checkbox()
        end, { buffer = vim.api.nvim_get_current_buf() })
        inoremap("<c-w>p", function()
          markdown.insert_link()
        end, { buffer = vim.api.nvim_get_current_buf() })
        nnoremap("<c-a>b", function()
          markdown.toggle_bullet()
        end, { buffer = vim.api.nvim_get_current_buf() })
        nnoremap("<c-a>c", function()
          markdown.toggle_checkbox()
        end, { buffer = vim.api.nvim_get_current_buf() })
        vnoremap("<c-a>b", function()
          markdown.toggle_bullet()
        end, { buffer = vim.api.nvim_get_current_buf() })
        vnoremap("<c-a>c", function()
          markdown.toggle_checkbox()
        end, { buffer = vim.api.nvim_get_current_buf() })
      end,
    },
  },
}

c.lang00 = color.darken(c.base00, 15)
groups.new("CodeBlock", { guifg = nil, guibg = c.lang00, gui = "none", guisp = nil })

vim.fn.sign_define("codeblock", {
  linehl = "CodeBlock",
})