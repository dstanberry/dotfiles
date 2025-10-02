---@class remote.snacks.res
---@field dashboard remote.snacks.res.dashboard
---@field gitbrowse remote.snacks.res.gitbrowse
---@field lazygit remote.snacks.res.lazygit
---@field indent remote.snacks.res.indent
---@field notify remote.snacks.res.notify
---@field picker remote.snacks.res.picker
---@field scratch remote.snacks.res.scratch
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("remote.snacks.res." .. k)
    return rawget(t, k)
  end,
})

M.styles = {
  input = {
    row = 19,
  },
  notification = {
    border = vim.tbl_map(function(icon) return { icon, "FloatBorder" } end, ds.icons.border.Default),
    wo = {
      wrap = true,
    },
  },
  notification_history = {
    wo = {
      cursorline = false,
      winhighlight = "Title:SnacksNotifierHistoryTitle",
    },
  },
  scratch = {
    wo = {
      winhighlight = "CursorLine:SnacksScratchCursorLine",
    },
  },
  terminal = {
    wo = {
      winbar = "",
    },
  },
}

return M
