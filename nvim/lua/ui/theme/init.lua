local groups = require "ui.theme.groups"

local M = {}

M.colors = {}

M.themes = {
  kdark = require "ui.theme.colors.kdark",
}

M.setup = function(t)
  if type(t) == "string" then
    t = M.themes[t]
  end
  M.colors = vim.F.if_nil(t, M.themes.kdark)
  groups.apply(M.colors)
end

return M
