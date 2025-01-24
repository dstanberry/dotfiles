local M = {}

M.theme = {
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
}

return M
