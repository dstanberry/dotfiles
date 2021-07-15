---------------------------------------------------------------
-- => Colorscheme Configuration
---------------------------------------------------------------
-- load colorscheme utilities
local themes = require "ui.theme.colors"
local groups = require "ui.theme.groups"

-- initialize modules table
local M = {}

-- assign all available color palettes
M.colorschemes = themes

-- define colorscheme
M.setup = function(colors)
  -- lookup requested theme
  if type(colors) == "string" then
    colors = M.colorschemes[colors]
  end
  -- fallback to a safe theme if `colors` not found
  M.colors = colors or M.colorschemes["base16-kdark"]
  groups.apply(M.colors)
end

return M
