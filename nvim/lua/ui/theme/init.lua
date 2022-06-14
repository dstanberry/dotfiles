-- load colorscheme utilities
local themes = require "ui.theme.colors"
local groups = require "ui.theme.groups"

local M = {}

-- assign all available color palettes
M.colorschemes = themes

-- define colorscheme
M.setup = function(t)
  -- lookup requested theme
  if type(t) == "string" then
    t = M.colorschemes[t]
  end
  -- fallback to a safe theme if `colors` not found
  M.colors = t or M.colorschemes["kdark"]
  groups.apply(M.colors)
end

return M
