-- verify diffview is available
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

local cb = require("diffview.config").diffview_callback

diffview.setup {
  diff_binaries = false,
  use_icons = true,
  enhanced_diff_hl = false,
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
  key_bindings = {
    disable_defaults = false,
    view = {
      ["<tab>"] = cb "select_next_entry",
      ["<s-tab>"] = cb "select_prev_entry",
      ["gf"] = cb "goto_file",
      ["<C-w><C-f>"] = cb "goto_file_split",
      ["<C-w>gf"] = cb "goto_file_tab",
      ["<leader>e"] = cb "focus_files",
      ["<leader>b"] = cb "toggle_files",
    },
    file_panel = {
      ["j"] = cb "next_entry",
      ["<down>"] = cb "next_entry",
      ["k"] = cb "prev_entry",
      ["<up>"] = cb "prev_entry",
      ["<cr>"] = cb "select_entry",
      ["o"] = cb "select_entry",
      ["<2-LeftMouse>"] = cb "select_entry",
      ["-"] = cb "toggle_stage_entry",
      ["S"] = cb "stage_all",
      ["U"] = cb "unstage_all",
      ["X"] = cb "restore_entry",
      ["R"] = cb "refresh_files",
      ["<tab>"] = cb "select_next_entry",
      ["<s-tab>"] = cb "select_prev_entry",
      ["gf"] = cb "goto_file",
      ["<C-w><C-f>"] = cb "goto_file_split",
      ["<C-w>gf"] = cb "goto_file_tab",
      ["<leader>e"] = cb "focus_files",
      ["<leader>b"] = cb "toggle_files",
    },
    file_history_panel = {
      ["g!"] = cb "options",
      ["<C-d>"] = cb "open_in_diffview",
      ["zR"] = cb "open_all_folds",
      ["zM"] = cb "close_all_folds",
      ["j"] = cb "next_entry",
      ["<down>"] = cb "next_entry",
      ["k"] = cb "prev_entry",
      ["<up>"] = cb "prev_entry",
      ["<cr>"] = cb "select_entry",
      ["o"] = cb "select_entry",
      ["<2-LeftMouse>"] = cb "select_entry",
      ["<tab>"] = cb "select_next_entry",
      ["<s-tab>"] = cb "select_prev_entry",
      ["gf"] = cb "goto_file",
      ["<C-w><C-f>"] = cb "goto_file_split",
      ["<C-w>gf"] = cb "goto_file_tab",
      ["<leader>e"] = cb "focus_files",
      ["<leader>b"] = cb "toggle_files",
    },
    option_panel = {
      ["<tab>"] = cb "select",
      ["q"] = cb "close",
    },
  },
}
