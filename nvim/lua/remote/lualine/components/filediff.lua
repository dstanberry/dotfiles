local util = require "remote.lualine.util"

local add = util.add
local highlighter = util.highlighter

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

  if ds.contains(vim.g.ds_excludes.ft.wb_empty, ft) then return " " end

  return add(highlighter.sanitize "@variable.builtin", { vim.api.nvim_buf_get_var(buf, "diffview_label") }, true)
end
