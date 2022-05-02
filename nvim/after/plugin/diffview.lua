-- verify diffview is available
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

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
