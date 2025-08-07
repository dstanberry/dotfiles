---@class util.ft: util.ft.base
local M = {}

local core = require "ft"

setmetatable(M, {
  __index = function(t, k)
    if core[k] then return core[k] end
    t[k] = require("ft." .. k)
    return t[k]
  end,
})

---Filetypes disabled for specific UI components
---@type table<string, string[]>
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
    "snacks_terminal",
    "trouble",
  },
}

---Filetypes considered empty for specific UI components
---@type table<string, string[]>
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

---Filetypes that can be closed quickly with 'q'
---@type string[]
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
