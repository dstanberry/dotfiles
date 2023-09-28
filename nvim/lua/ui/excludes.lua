local M = {}

M.bt = {
  stl_disabled = {},
  wb_disabled = {
    "terminal",
    "nofile",
    "prompt",
  },
}

M.ft = {
  stl_disabled = {
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
    "Trouble",
  },
  wb_disabled = {
    -- builtin filetypes
    "help",
    "gitcommit",
    "qf",
    "term",

    -- plugin filetypes
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
    "Trouble",
  },
  wb_empty = {
    -- builtin filetypes
    "help",

    -- plugin filetypes
    "dbui",
    "DiffviewFileHistory",
    "DiffviewFilePanel",
    "DiffviewFiles",
  },
}

return M
