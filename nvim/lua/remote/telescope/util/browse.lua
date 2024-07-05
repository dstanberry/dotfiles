---@class remote.telescope.util.browse
local M = {}

function M.project()
  require("telescope").extensions.file_browser.file_browser {
    path = ds.buffer.get_root(),
    prompt_title = "File Browser",
  }
end

function M.current_directory()
  require("telescope").extensions.file_browser.file_browser {
    path = "%:p:h",
    prompt_title = "File Browser",
  }
end

return M
