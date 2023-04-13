local M = {}

M.bt = {}

M.bt.stl_disabled = {}

M.bt.wb_disabled = {
  "terminal",
  "nofile",
  "prompt",
}

M.ft = {}

M.ft.stl_disabled = {
  -- builtin filetypes
  "help",
  "qf",
  "term",

  -- plugin filetypes
  "dbui",
  "DiffviewFiles",
  "gitcommit",
  "lazy",
  "mason",
  "neo-tree",
  "NeogitPopup",
  "NeogitStatus",
  "noice",
  "TelescopePrompt",
  "toggleterm",
}

M.ft.wb_disabled = {
  -- builtin filetypes
  "help",
  "gitcommit",
  "qf",
  "term",

  -- plugin filetypes
  "Bqf.*",
  "dap-repl",
  "dbout",
  "lazy",
  "mason",
  "neo-tree",
  "NeogitCommitMessage",
  "NeogitPopup",
  "NeogitStatus",
  "noice",
  "TelescopePrompt",
  "toggleterm",
}

M.ft.wb_empty = {
  -- builtin filetypes
  "help",

  -- plugin filetypes
  "dbui",
  "DiffviewFilePanel",
  "DiffviewFiles",
}

return M
