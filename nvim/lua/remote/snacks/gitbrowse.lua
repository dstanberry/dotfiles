local M = {}

local ghe = vim.g.ds_env.github_hostname

M.browse = {
  open = ds.has "wsl" and function(url) vim.system { "cmd.exe", "/c", "start", url } end,
  url_patterns = ghe and { [ghe] = { branch = "/tree/{branch}", file = "/blob/{branch}/{file}#L{line}" } },
}

M.copy_url = { url_pattern = M.browse.url_patterns, open = function(url) vim.fn.setreg("+", url) end }

return M
