local M = {}

local ghe = vim.g.ds_env.github_hostname

M.browse = {
  open = ds.has "wsl" and function(url) vim.system { "cmd.exe", "/c", "start", url } end,
  url_patterns = ghe and { [ghe] = { branch = "/tree/{branch}", file = "/blob/{branch}/{file}#L{line}" } },
}

M.copy_url = { url_pattern = M.browse.url_patterns, open = function(url) vim.fn.setreg("+", url) end }

M.lazygit = {
  theme = {
    [241] = { fg = "Special" },
    defaultFgColor = { fg = "Normal" },
    activeBorderColor = { fg = "Function", bold = true },
    inactiveBorderColor = { fg = "Comment" },
    optionsTextColor = { fg = "Function" },
    selectedLineBgColor = { bg = "Visual" },
    unstagedChangesColor = { fg = "DiagnosticError" },
    cherryPickedCommitBgColor = { bg = "default" },
    cherryPickedCommitFgColor = { fg = "Identifier" },
    searchingActiveBorderColor = { fg = "MatchParen", bold = true },
  },
}

return M
