local M = {}

local function label()
  return "Packer"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

M.filetypes = {
  "packer",
}

return M
