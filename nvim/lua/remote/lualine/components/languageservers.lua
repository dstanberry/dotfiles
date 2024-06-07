local icons = require "ui.icons"
local util = require "util"

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local limit = math.floor(0.15 * vim.fn.winwidth(winid))
  local clients = util.map(vim.lsp.get_clients { bufnr = buf }, function(client)
    if client and client.name then return client.name end
  end)
  local names = clients and table.concat(clients, ds.pad(icons.misc.CircleDot, "both")) or ""
  return #names == 0 and ""
    or #names < limit and ds.pad(icons.misc.Gears, "right", 2) .. names
    or ds.pad(icons.misc.Gears, "right", 2) .. "LSP"
end
