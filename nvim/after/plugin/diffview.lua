-- verify diffview is available
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

c.diff00 = "#132e1f"
c.diff01 = "#361f21"
c.diff02 = "#403c32"
c.diff03 = "#6B6458"

groups.new("DiffAdd", { guifg = "none", guibg = c.diff00, gui = "none", guisp = nil })
groups.new("DiffChange", { guifg = "none", guibg = c.diff02, gui = "none", guisp = nil })
groups.new("DiffDelete", { guifg = "none", guibg = c.diff01, gui = "none", guisp = nil })
groups.new("DiffText", { guifg = "none", guibg = c.diff03, gui = "none", guisp = nil })

diffview.setup {
  diff_binaries = false,
  use_icons = true,
  enhanced_diff_hl = true,
  icons = {
    folder_closed = " ",
    folder_open = " ",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    position = "bottom",
    width = 35,
    height = 10,
  },
  file_history_panel = {
    position = "bottom",
    width = 35,
    height = 16,
    log_options = {
      max_count = 256,
      follow = false,
      all = false,
      merges = false,
      no_merges = false,
      reverse = false,
    },
  },
}

diffview.init()
