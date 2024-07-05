---@class remote.telescope.util.grep
local M = {}

function M.buffer()
  require("telescope.builtin").current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = "Find in Buffer",
    sorting_strategy = "ascending",
  }
end

function M.dynamic() require("telescope.builtin").live_grep() end

function M.dynamic_args() require("telescope").extensions.live_grep_args.live_grep_args() end

function M.register()
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
  require("telescope.builtin").grep_string {
    path_display = { "shorten" },
    search = register,
    word_match = "-w",
  }
end

return M
