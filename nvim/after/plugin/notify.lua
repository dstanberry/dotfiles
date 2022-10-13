-- verify notify is available
local ok, notify = pcall(require, "notify")
if not ok then
  return
end

local telescope = require "telescope"

notify.setup {
  stages = "fade_in_slide_out",
  timeout = 3000,
  background_colour = "Normal",
  render = function(...)
    local n = select(2, ...)
    local style = n.title[1] == "" and "minimal" or "default"
    require("notify.render")[style](...)
  end,
}

vim.notify = notify

pcall(telescope.load_extension "notify")
