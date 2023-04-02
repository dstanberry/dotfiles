local icons = require "ui.icons"
local util = require "util"

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local limit = math.floor(0.15 * vim.fn.winwidth(winid))
  local clients = util.map(function(names, client, _)
    if client.name and client.name ~= "null-ls" then table.insert(names, client.name) end
    return names
  end, vim.lsp.get_active_clients { bufnr = buf })

  local names = clients and table.concat(clients, ", ") or ""
  return #names == 0 and ""
    or #names < limit and pad(icons.misc.Gears, "right", 2) .. names
    or pad(icons.misc.Gears, "right") .. "LSP"
end
