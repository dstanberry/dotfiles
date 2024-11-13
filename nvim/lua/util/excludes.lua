---@class util.excludes
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
    "copilot-chat",
    "dashboard",
    "dbui",
    "DiffviewFiles",
    "gitcommit",
    "lazy",
    "mason",
    "NeogitPopup",
    "NeogitStatus",
    "noice",
    "oil",
    "TelescopePrompt",
    "toggleterm",
    "trouble",
  },
  wb_disabled = {
    -- builtin filetypes
    "help",
    "gitcommit",
    "qf",
    "term",

    -- plugin filetypes
    "copilot-chat",
    "dap-repl",
    "dbui",
    "DiffviewFileHistory",
    "dbout",
    "grug-far",
    "lazy",
    "mason",
    "NeogitCommitMessage",
    "NeogitPopup",
    "NeogitStatus",
    "noice",
    "octo_panel",
    "TelescopePrompt",
    "toggleterm",
    "trouble",
  },
  wb_empty = {
    -- builtin filetypes
    "help",

    -- plugin filetypes
    "DiffviewFilePanel",
    "DiffviewFiles",
  },
}

return M
