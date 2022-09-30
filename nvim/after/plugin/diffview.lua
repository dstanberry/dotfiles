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
  view = {
    default = { layout = "diff2_horizontal" },
    file_history = { layout = "diff2_horizontal" },
    merge_tool = { layout = "diff3_horizontal" },
  },
  file_panel = {
    listing_style = "tree",
    win_config = {
      position = "left",
      width = 35,
      height = 10,
      win_opts = { winhighlight = "Normal:NormalSB,SignColumn:SignColumnSB" },
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 16,
      win_opts = { winhighlight = "Normal:NormalSB,SignColumn:SignColumnSB" },
    },
    log_options = {
      single_file = {
        max_count = 256,
        follow = false,
        all = false,
        merges = false,
        no_merges = false,
        reverse = false,
      },
      multi_file = {
        max_count = 256,
        follow = false,
        all = false,
        merges = false,
        no_merges = false,
        reverse = false,
      },
    },
  },
}

diffview.init()
