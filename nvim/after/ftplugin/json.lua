vim.keymap.set("n", "o", function()
  local reserved_chars = { "", ",", ":", "{", "[" }
  local char = vim.api.nvim_get_current_line():sub(-1)
  local trailing = vim.tbl_contains(reserved_chars, char) and "" or ","
  return ("A%s<cr>"):format(trailing)
end, { buffer = true, expr = true })
