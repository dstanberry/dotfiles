---@class remote.lualine.component.git
local M = {}

local util = require "remote.lualine.util"
local add = util.add
local highlighter = util.highlighter

M.branch = {
  get = function()
    local icon = ds.pad(ds.icons.git.Branch, "right")
    if package.loaded["gitsigns"] then
      local branch = vim.b.gitsigns_head
      if not branch or #branch == 0 then return ds.pad(ds.icons.misc.Orbit, "right") end
      return icon .. branch
    end
    return ds.pad(ds.icons.misc.Orbit, "right")
  end,
}

M.diff = {
  get = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end,
}

M.diffview = {
  get = function()
    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ds.tbl_match(ds.ft.empty.winbar, ft) then return " " end
    return add(highlighter.sanitize "@variable.builtin", { vim.api.nvim_buf_get_var(buf, "diffview_label") }, true)
  end,
  cond = function() return package.loaded["diffview"] and require("diffview.lib").get_current_view() ~= nil end,
}

M.merge_conflicts = {
  get = function()
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
          diffview_info = ds.replace(diffview_info, "OURS (Current changes)", "")
          diffview_info = ds.replace(diffview_info, "THEIRS (Incoming changes)", "")
          diffview_info = ds.replace(diffview_info, "BASE (Common ancestor)", "")
          diffview_info = vim.trim(diffview_info)
          ret = diffview_info
        end
      end
      return add(highlighter.sanitize "@variable.builtin", { ret }, true)
    end

    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

    if ds.tbl_match(ds.ft.empty.winbar, ft) then return " " end
    return string.format("%s%s", format_label(winid, buf), highlighter.reset)
  end,
}

return M
