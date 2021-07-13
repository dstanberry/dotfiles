---------------------------------------------------------------
-- => tabline configuration
---------------------------------------------------------------
-- check if available
local ok, tabline = pcall(require, "buftabline")
if not ok then
  return
end

-- default options
tabline.setup {
  disable_commands = true,
  icons = true,
  go_to_maps = true,
  start_hidden = true,
}
