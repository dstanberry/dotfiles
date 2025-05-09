---@class remote.snacks.util.dashboard
local M = {}

M.config = {
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "startup" },
  },
  preset = {
    keys = {
      {
        key = "f",
        desc = "Find File",
        action = function() Snacks.picker.files() end,
        icon = ds.pad(ds.icons.misc.Magnify, "right"),
      },
      {
        key = "g",
        desc = "Find Text",
        action = function() Snacks.picker.grep() end,
        icon = ds.pad(ds.icons.misc.Data, "right"),
      },
      {
        key = "n",
        desc = "New File",
        action = ":ene | startinsert",
        icon = ds.pad(ds.icons.documents.File, "right"),
      },
      {
        key = "r",
        desc = "Restore Session",
        action = function() require("persistence").load() end,
        icon = ds.pad(ds.icons.misc.Revolve, "right"),
      },
      {
        key = "c",
        desc = "User Config",
        action = function() Snacks.picker.files { cwd = tostring(vim.fn.stdpath "config") } end,
        icon = ds.pad(ds.icons.misc.Gear, "right"),
      },
      {
        key = "l",
        desc = "Plugins",
        action = ":Lazy",
        icon = ds.pad(ds.icons.misc.Extensions, "right"),
      },
      {
        key = "q",
        desc = "Quit",
        action = ":qa",
        icon = ds.pad(ds.icons.misc.Exit, "right"),
      },
    },
  },
}

return M
