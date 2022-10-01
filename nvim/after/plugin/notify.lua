-- verify notify is available
local ok, notify = pcall(require, "notify")
if not ok then
  return
end

local telescope = require("telescope")

notify.setup {
  stages = "slide",
  timeout = 5000,
  background_colour = "Normal",
}

vim.notify = notify

pcall(telescope.load_extension "notify")
