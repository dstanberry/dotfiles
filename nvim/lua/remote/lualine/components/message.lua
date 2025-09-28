---@class remote.lualine.component.message
local M = {}

local util = require "remote.lualine.util"

M.codecompanion = {
  ctx = {
    get = function()
      local base = ds.icons.kind.Copilot
      local buf = _G.codecompanion_current_context
      if not buf then return base end
      local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
      local filename = (filepath):match "^.+/(.+)$"
      return string.format("[ %s %s ]  %s ", ds.icons.documents.SymbolicLink, filename, base)
    end,
    cond = function() return package.loaded.codecompanion and vim.bo.filetype == "codecompanion" end,
  },
  adapter = {
    get = function()
      local buf = vim.api.nvim_get_current_buf()
      local data = _G.codecompanion_chat_metadata and _G.codecompanion_chat_metadata[buf]
      if not data.adapter and data.adapter.name then return "" end
      return string.format(
        "%s (%s) - %d tokens",
        data.adapter.name or "",
        data.adapter.model,
        _G.codecompanion_ds_tokens or 0
      )
    end,
    cond = function() return package.loaded.codecompanion and vim.bo.filetype == "codecompanion" end,
  },
}

M.noice = {
  get = function()
    local text = require("noice").api.status.search.get()
    local query = text:match "%/(.-)%s" or text:match "%?(.-)%s" or ""
    local counter = text:match "%d+%/%d+"
    return string.format("%s %s [%s]", ds.icons.misc.Magnify, query, counter)
  end,
  cond = function()
    return package.loaded.noice and require("noice").api.status.search.has() and util.available_width(80)
  end,
}

return M
