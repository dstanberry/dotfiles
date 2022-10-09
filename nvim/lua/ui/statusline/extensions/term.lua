local M = {}

local function label()
  return "Terminal |" .. vim.o.shell .. "|"
end

M.sections = {
  left = { { user2 = label } },
  right = {},
}

return M
