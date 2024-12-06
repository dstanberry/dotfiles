---@class remote.telescope.util.files
local M = {}

function M.default() require("telescope.builtin").find_files() end

function M.nvim_config()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "config",
    prompt_title = "Neovim RC Files",
  }
end

function M.plugins()
  require("telescope.builtin").find_files {
    cwd = require("lazy.core.config").options.root,
    layout_strategy = "vertical",
    prompt_title = "Remote Plugins",
  }
end

function M.plugin_spec()
  local files = {}
  ds.fs.walk("remote", function(path, name, type)
    if (type == "file" or type == "link") and name:match "%.lua$" then
      if name == "init.lua" or vim.fs.dirname(path):match "remote$" then files[path] = path end
    end
  end)
  require("telescope.builtin").live_grep {
    default_text = "/",
    search_dirs = vim.tbl_values(files),
    prompt_title = "Remote Plugin Specs",
  }
end

function M.project()
  local git = vim.fs.find(".git", { upward = true })
  if #git >= 1 then
    require("telescope.builtin").git_files {
      prompt_title = "Project Files (Git)",
      show_untracked = true,
    }
  else
    require("telescope.builtin").find_files { prompt_title = "Project Files" }
  end
end

function M.recent()
  require("telescope.builtin").oldfiles {
    prompt_title = "Recent Files",
  }
end

return M
