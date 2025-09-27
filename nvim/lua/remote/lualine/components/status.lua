---@class remote.lualine.component.status
local M = {}

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

return M
