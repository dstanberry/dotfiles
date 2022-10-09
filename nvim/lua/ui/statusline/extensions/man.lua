local M = {}

local label = function()
  return "MAN"
end

M.sections = {
  left = {
    { user2 = label },
    { user8 = { "filename", relative = false } },
  },
  right = {},
}

return M
