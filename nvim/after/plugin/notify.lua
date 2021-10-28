-- verify buftabline is available
local ok, notify = pcall(require, "notify")
if not ok then
  return
end

notify.setup {
  stages = "slide",
  timeout = 50000,
  background_colour = "Normal",
}
