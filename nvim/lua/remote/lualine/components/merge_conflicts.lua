local util = require "util"
local excludes = require "ui.excludes"
local stl_util = require "remote.lualine.util"

local add = stl_util.add
local highlighter = stl_util.highlighter

local format_label = function(winid, bufnr)
  local ret = ""
  local diffview_label = vim.api.nvim_buf_get_var(bufnr, "diffview_label")
  local diffview_view = vim.api.nvim_buf_get_var(bufnr, "diffview_view")
  local diffview_info = vim.api.nvim_buf_get_var(bufnr, "diffview_info")
  if diffview_view == "merge" then
    if diffview_label:lower() == "result" then
      local vcs_util = require "diffview.vcs.utils"
      local conflicts, _, _ = vcs_util.parse_conflicts(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), winid)
      local count = #conflicts or 0
      ret = count == 1 and "1 remaining conflict" or ("%s remaining conflicts"):format(count)
    else
      diffview_info = util.replace(diffview_info, "OURS (Current changes)", "")
      diffview_info = util.replace(diffview_info, "THEIRS (Incoming changes)", "")
      diffview_info = util.replace(diffview_info, "BASE (Common ancestor)", "")
      diffview_info = vim.trim(diffview_info)
      ret = diffview_info
    end
  end
  return add(highlighter.sanitize "@variable.builtin", { ret }, true)
end

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

  if util.contains(excludes.ft.wb_empty, ft) then return " " end

  return string.format("%s%s", format_label(winid, buf), highlighter.reset)
end
