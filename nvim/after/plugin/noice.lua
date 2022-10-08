-- verify noice is available
local ok, noice = pcall(require, "noice")
if not ok then
  return
end

local telescope = require "telescope"
local icons = require "ui.icons"

noice.setup {
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
      border = {
        style = "none",
        padding = { 2, 3 },
      },
      filter_options = {},
      win_options = {
        winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NormalFloat" },
      },
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
