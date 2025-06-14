---@class remote.snacks.util
---@field dashboard remote.snacks.util.dashboard
---@field gitbrowse remote.snacks.util.gitbrowse
---@field lazygit remote.snacks.util.lazygit
---@field indent remote.snacks.util.indent
---@field notify remote.snacks.util.notify
---@field picker remote.snacks.util.picker
---@field scratch remote.snacks.util.scratch
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("remote.snacks.util." .. k)
    return rawget(t, k)
  end,
})

M.augroup = ds.augroup "snacks"

M.styles = {
  input = {
    row = 19,
  },
  notification = {
    wo = {
      wrap = true,
    },
  },
  notification_history = {
    wo = {
      cursorline = false,
      winhighlight = "FloatBorder:FloatBorderSB,Title:SnacksNotifierHistoryTitle",
    },
  },
  scratch = {
    wo = {
      winhighlight = "FloatBorder:FloatBorderSB,CursorLine:SnacksScratchCursorLine",
    },
  },
  snacks_image = {
    border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
  },
  terminal = {
    wo = {
      winbar = "",
    },
  },
}

return M
