---@class remote.snacks.res.lazygit
local M = {}

M.config = {
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
  win = {
    keys = {
      cj = { "<c-j>", "ctrl_j", expr = true, mode = "t" },
      ck = { "<c-k>", "ctrl_k", expr = true, mode = "t" },
    },
    actions = { ctrl_j = function() return "<c-j>" end, ctrl_k = function() return "<c-k>" end },
  },
}

return M
