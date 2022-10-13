-- verify noice is available
local ok, noice = pcall(require, "noice")
local DISABLED = true
if not ok or DISABLED then
  return
end

local telescope = require "telescope"
local icons = require "ui.icons"

noice.setup {
  popupmenu = {
    backend = "cmp",
  },
  cmdline = {
    view = "cmdline_popup",
    opts = {
      buf_options = { filetype = "vim" },
    },
    icons = {
      ["/"] = { icon = icons.misc.ChevronRight, hl_group = "String" },
      ["?"] = { icon = icons.misc.ChevronRight, hl_group = "String" },
      [":"] = { icon = icons.misc.ChevronRight, hl_group = "String", firstc = false },
    },
  },
  views = {
    cmdline_popup = {
      filter_options = {},
      position = { row = 10, col = "50%" },
      border = {
        style = "none",
        padding = { 2, 3 },
      },
      win_options = {
        winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NormalFloat" },
      },
    },
    popupmenu = {
      relative = "editor",
      position = { row = 13, col = "50%" },
      size = { width = 60, height = 10 },
    },
  },
  routes = {
    {
      filter = { event = "msg_show", kind = "", find = "written" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", kind = "search_count" },
      opts = { skip = true },
    },
  },
}

pcall(telescope.load_extension "noice")
