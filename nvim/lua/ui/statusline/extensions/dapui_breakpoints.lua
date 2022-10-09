local M = {}

local function label()
  return "DAP Breakpoints"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

return M
