-- verify diffview is available
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

local lazy = require "diffview.lazy"
local lib = lazy.require "diffview.lib"
local Diff2Hor = lazy.access("diffview.scene.layouts.diff_2_hor", "Diff2Hor")
local Diff2Ver = lazy.access("diffview.scene.layouts.diff_2_ver", "Diff2Ver")
local Diff3 = lazy.access("diffview.scene.layouts.diff_3", "Diff3")
local Diff4 = lazy.access("diffview.scene.layouts.diff_4", "Diff4")

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
    merge_tool = { layout = "diff3_mixed" },
  },
  file_panel = {
    listing_style = "tree",
    win_config = {
      position = "left",
      width = 35,
      height = 10,
      win_opts = { winhighlight = "Normal:NormalSB" },
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 20,
      win_opts = { winhighlight = "Normal:NormalSB" },
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
  hooks = {
    diff_buf_read = function(bufnr, _)
      local view = lib.get_current_view()
      local file = view.cur_entry
      local target = ""
      if file then
        local layout = file.layout
        if layout:instanceof(Diff2Hor.__get()) or layout:instanceof(Diff2Ver.__get()) then
          if bufnr == layout.a.file.bufnr then
            target = "OLD STATE"
          elseif bufnr == layout.b.file.bufnr then
            target = "NEW STATE"
          end
        elseif layout:instanceof(Diff3.__get()) then
          if bufnr == layout.a.file.bufnr then
            target = "OURS (current branch)"
          elseif bufnr == layout.b.file.bufnr then
            target = "LOCAL (file on disk)"
          elseif bufnr == layout.c.file.bufnr then
            target = "THEIRS (incoming branch)"
          end
        elseif layout:instanceof(Diff4.__get()) then
          if bufnr == layout.a.file.bufnr then
            target = "OURS (current branch)"
          elseif bufnr == layout.b.file.bufnr then
            target = "LOCAL (file on disk)"
          elseif bufnr == layout.c.file.bufnr then
            target = "THEIRS (incoming branch)"
          elseif bufnr == layout.d.file.bufnr then
            target = "BASE (common ancestor)"
          end
        end
        vim.api.nvim_buf_set_var(bufnr, "bufid", "diffview")
        vim.api.nvim_buf_set_var(bufnr, "diffview_label", target)
      end
    end,
  },
}

diffview.init()
