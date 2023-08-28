local M = {}

M.handle_return = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local node = vim.treesitter.get_node { bufnr = 0, pos = { cursor[1] - 1, 0 } }
  if node then
    local capture = node:type()
    local text = vim.treesitter.get_node_text(node, 0)
    local newtext = ""

    if capture == "checkbox_unchecked" or capture == "checkbox_checked" then
      newtext = "[ ] "
    elseif capture == "list_marker_dot" then
      local next = tonumber(text:sub(1, 1))
      if next and type(next) == "number" then newtext = ("%s. "):format(next + 1) end
    elseif capture == "list_marker_minus" then
      newtext = ("%s "):format(text:sub(1, 1))
    end
    vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], false, { newtext })
    vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, #newtext + 1 })
  end
end

return M
