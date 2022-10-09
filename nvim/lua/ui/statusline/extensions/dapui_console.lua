local M = {}

local function label()
  return "DAP Console"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

return M
