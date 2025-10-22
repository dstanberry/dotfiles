---@class remote.snacks.stash
---@field dashboard remote.snacks.stash.dashboard
---@field gitbrowse remote.snacks.stash.gitbrowse
---@field lazygit remote.snacks.stash.lazygit
---@field indent remote.snacks.stash.indent
---@field util remote.snacks.stash.util
---@field picker remote.snacks.stash.picker
---@field scratch remote.snacks.stash.scratch
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("remote.snacks.stash." .. k)
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
    border = "rounded",
    wo = {
      cursorline = false,
      winhighlight = "Title:SnacksNotifierHistoryTitle",
    },
  },
  scratch = {
    border = "rounded",
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
