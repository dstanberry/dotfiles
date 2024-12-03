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
    "dbui",
    "DiffviewFiles",
    "gitcommit",
    "lazy",
    "mason",
    "noice",
    "oil",
    "snacks_dashboard",
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
