---------------------------------------------------------------
-- => tabline configuration
---------------------------------------------------------------
-- check if available
local has_tabline, tabline = pcall(require, "buftabline")
if not has_tabline then
  return
end

-- default options
local opts = {
  disable_commands = true,
  icons = true,
  go_to_maps = true,
  start_hidden = true,
}

-- setup tabline
tabline.setup(opts)
