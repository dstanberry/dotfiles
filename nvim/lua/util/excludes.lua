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
    "snacks_input",
    "snacks_notif_history",
    "snacks_picker_input",
    "snacks_picker_list",
    "snacks_terminal",
    "TelescopePrompt",
    "TelescopeResults",
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
    "snacks_terminal",
    "TelescopePrompt",
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
