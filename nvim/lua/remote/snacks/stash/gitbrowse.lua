---@class remote.snacks.stash.gitbrowse
local M = {}

local ghe = vim.g.ds_env.github_hostname

M.config = {
  open = ds.has "wsl" and function(url) vim.system { "cmd.exe", "/c", "start", url } end or nil,
  url_patterns = ghe and {
    [vim.pesc(ghe)] = {
      branch = "/tree/{branch}",
      commit = "/commit/{commit}",
      file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
    },
  } or nil,
}

M.copy_url = {
  notify = false,
  open = function(url)
    vim.fn.setreg("+", url)
    ds.info("URL copied to clipboard.\n\n" .. url)
  end,
}

return M
