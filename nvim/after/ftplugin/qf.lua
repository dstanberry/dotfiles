local util = require "util"

vim.opt_local.buflisted = false
vim.opt_local.colorcolumn = ""
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "yes"
vim.opt_local.winfixheight = true
vim.opt_local.wrap = false

vim.keymap.set("n", "<cr>", function()
  local linenr = vim.fn.line "."
  vim.cmd.cc { count = linenr }
end, { buffer = vim.api.nvim_get_current_buf(), desc = "quickfix: goto item" })

vim.keymap.set(
  "n",
  "dd",
  util.buffer.quickfix_delete,
  { buffer = vim.api.nvim_get_current_buf(), desc = "quickfix: delete item" }
)
vim.keymap.set(
  "v",
  "d",
  util.buffer.quickfix_delete,
  { buffer = vim.api.nvim_get_current_buf(), desc = "quickfix: delete item" }
)

vim.keymap.set(
  "n",
  "H",
  function() pcall(vim.cmd.colder) end,
  { buffer = vim.api.nvim_get_current_buf(), desc = "quickfix: goto older item" }
)
vim.keymap.set(
  "n",
  "L",
  function() pcall(vim.cmd.cnewer) end,
  { buffer = vim.api.nvim_get_current_buf(), desc = "quickfix: goto newer item" }
)

local adjust_height = function(min_height, max_height)
  local line_end = vim.fn.line "$" + 1
  local ceil = math.min(line_end, max_height)
  local size = math.max(min_height, ceil)
  vim.cmd.wincmd { args = { "_" }, count = size, range = { size } }
  vim.cmd.wincmd { args = { "J" } }
end

adjust_height(3, 10)
