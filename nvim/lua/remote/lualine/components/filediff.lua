local util = require "util"
local stl_util = require "remote.lualine.util"
local filetypes = require "remote.lualine.filetypes"

local add = stl_util.add
local highlighter = stl_util.highlighter

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if util.contains(filetypes.wb_suppressed, ft) then return " " end
  return add(highlighter.sanitize "@variable.builtin", { vim.api.nvim_buf_get_var(buf, "diffview_label") }, true)
end
