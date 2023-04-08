local has_signs, _ = pcall(require, "gitsigns")
local icons = require "ui.icons"

local show_buffer_info = function(bufnr)
  local icon = pad(icons.misc.Orbit, "right")
  for i, b in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr == b then return icon, i end
  end
end

return function()
  local buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  local icon = pad(icons.git.Branch, "right")
  local ok, branch
  if has_signs then
    ---@diagnostic disable-next-line: undefined-field
    branch = vim.b.gitsigns_head
    if not branch or #branch == 0 then
      icon, branch = show_buffer_info(buf)
    end
  end
  if not (ok or branch) then
    icon, branch = show_buffer_info(buf)
  end
  return icon .. branch
end
