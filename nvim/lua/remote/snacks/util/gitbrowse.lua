---@class remote.snacks.util.gitbrowse
local M = {}

local ghe = vim.g.ds_env.github_hostname

M.browse = {
  open = ds.has "wsl" and function(url) vim.system { "cmd.exe", "/c", "start", url } end,
  url_patterns = ghe and { [ghe] = { branch = "/tree/{branch}", file = "/blob/{branch}/{file}#L{line}" } },
}

M.copy_url = {
  notify = false,
  url_pattern = M.browse.url_patterns,
  open = function(url)
    vim.fn.setreg("+", url)
    ds.info("URL copied to clipboard.\n\n" .. url)
  end,
}

return M
