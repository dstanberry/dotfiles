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

---Filetypes disabled for statusline and winbar
---@type table<string, string[]>
M.disabled = {
  statusline = {
    -- builtin filetypes
    "help",
    "qf",
    "term",
    -- plugin filetypes
    "snacks_dashboard",
  },
  winbar = {
    -- builtin filetypes
    "help",
    "gitcommit",
    "qf",
    "term",
    -- plugin filetypes
    "codecompanion",
    "dap-repl",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_stacks",
    "dapui_watches",
    "dbout",
    "dbui",
    "DiffviewFileHistory",
    "DiffviewFilePanel",
    "DiffviewFiles",
    "grug-far",
    "lazy",
    "mason",
    "noice",
    "oil",
    "sidekick_terminal",
    "snacks_layout_box",
    "snacks_terminal",
    "trouble",
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
}

return M
