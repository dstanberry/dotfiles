local M = {}

local function label()
  return "Packer"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

return M
