---------------------------------------------------------------
-- => shade.nvim configuration
---------------------------------------------------------------
-- check if available
local ok, shade = pcall(require, "shade")
if not ok then
  return
end

-- default options
shade.setup {
  overlay_opacity = 50,
  opacity_step = 1,
  keys = {
    brightness_up = "<c-up>",
    brightness_down = "<c-down>",
    toggle = "<c-right>",
  },
}
