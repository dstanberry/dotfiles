local M = {}

local function label()
  return "ToggleTerm #" .. vim.b.toggle_number
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

M.filetypes = {
  "toggleterm",
}

return M
