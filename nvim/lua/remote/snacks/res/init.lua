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
