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
        action = require("remote.telescope.util").files.project,
        icon = ds.pad(ds.icons.misc.Magnify, "right"),
        desc = " Find File",
      },
      { key = "n", action = ":ene | startinsert", icon = ds.pad(ds.icons.documents.File, "right"), desc = " New File" },
      {
        key = "g",
        action = require("remote.telescope.util").grep.dynamic,
        icon = ds.pad(ds.icons.misc.Data, "right"),
        desc = " Find Text",
      },
      {
        key = "r",
        action = function() require("persistence").load() end,
        icon = ds.pad(ds.icons.misc.Revolve, "right"),
        desc = " Restore Session",
      },
      {
        key = "c",
        action = require("remote.telescope.util").files.nvim_config,
        icon = ds.pad(ds.icons.misc.Gear, "right"),
        desc = " Configuration File",
      },
      { key = "l", action = ":Lazy", icon = ds.pad(ds.icons.misc.Extensions, "right"), desc = " Plugin Manager" },
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
