local M = {}

local function label()
  return "Neogit"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

M.filetypes = {
  "NeogitPopup",
  "NeogitStatus"
}

return M
