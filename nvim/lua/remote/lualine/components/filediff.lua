local util = require "util"
local excludes = require "ui.excludes"
local stl_util = require "remote.lualine.util"

local add = stl_util.add
local highlighter = stl_util.highlighter

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

  if util.contains(excludes.ft.wb_empty, ft) then return " " end

  return add(highlighter.sanitize "@variable.builtin", { vim.api.nvim_buf_get_var(buf, "diffview_label") }, true)
end
