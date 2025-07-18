---@class util.ft
---@field disabled table<string, string[]> --- Filetypes disabled for specific UI components
---@field empty table<string, string[]> --- Filetypes considered empty for specific UI components
---@field quick_close string[] --- Filetypes that can be closed quickly with 'q'
local M = {}

M.disabled = {
  statusline = {
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
    "trouble",
  },
  winbar = {
    -- builtin filetypes
    "help",
    "gitcommit",
    "qf",
    "term",
    -- plugin filetypes
    "copilot-chat",
    "dap-repl",
    "dbout",
    "dbui",
    "DiffviewFileHistory",
    "grug-far",
    "lazy",
    "mason",
    "noice",
    "octo_panel",
    "oil",
    "snacks_terminal",
    "trouble",
  },
}

M.empty = {
  statusline = {},
  winbar = {
    -- builtin filetypes
    "help",
    -- plugin filetypes
    "DiffviewFilePanel",
    "DiffviewFiles",
  },
}

M.quick_close = {
  -- builtin filetypes
  "checkhealth",
  "help",
  "man",
  "notify",
  "qf",
  -- plugin filetypes
  "dbout",
  "neotest-output",
  "neotest-output-panel",
  "neotest-summary",
}

return M
