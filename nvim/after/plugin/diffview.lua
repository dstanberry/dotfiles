-- verify diffview is available
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

local icons = require "ui.icons"

diffview.setup {
  diff_binaries = false,
  use_icons = true,
  enhanced_diff_hl = true,
  icons = {
    folder_closed = pad(icons.documents.FolderClosed, "right"),
    folder_open = pad(icons.documents.FolderClosed, "right"),
  },
  signs = {
    fold_closed = icons.misc.FoldClosed,
    fold_open = icons.misc.FoldOpened,
  },
  file_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 10,
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 16,
    },
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
