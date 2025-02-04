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
        action = function() Snacks.picker.files() end,
        icon = ds.pad(ds.icons.misc.Magnify, "right"),
        desc = " Find File",
      },
      {
        key = "g",
        action = function() Snacks.picker.grep() end,
        icon = ds.pad(ds.icons.misc.Data, "right"),
        desc = " Find Text",
      },
      { key = "n", action = ":ene | startinsert", icon = ds.pad(ds.icons.documents.File, "right"), desc = " New File" },
      {
        key = "r",
        action = function() require("persistence").load() end,
        icon = ds.pad(ds.icons.misc.Revolve, "right"),
        desc = " Restore Session",
      },
      {
        key = "c",
        action = function() Snacks.picker.files { cwd = tostring(vim.fn.stdpath "config") } end,
        icon = ds.pad(ds.icons.misc.Gear, "right"),
        desc = " User Config",
      },
      { key = "l", action = ":Lazy", icon = ds.pad(ds.icons.misc.Extensions, "right"), desc = " Plugins" },
      {
        key = "q",
        action = function() vim.api.nvim_input "<cmd>qa<cr>" end,
        icon = ds.pad(ds.icons.misc.Exit, "right"),
        desc = " Quit",
      },
    },
  },
}

return M
