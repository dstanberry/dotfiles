local M = {}

local function label()
  return "DAP Scopes"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

return M
