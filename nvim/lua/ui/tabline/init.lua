local options = require "ui.tabline.options"
local highlights = require "ui.tabline.highlights"

local M = {}

local reset_icon_colors = vim.schedule_wrap(function()
  highlights.reset()
  vim.cmd "redrawtabline"
end)

M.setup = function(config)
  config = config or {}
  options.set(config)

  vim.api.nvim_create_augroup("tabline", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = "tabline",
    pattern = "*",
    callback = reset_icon_colors,
  })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = "tabline",
    pattern = "background",
    callback = reset_icon_colors,
  })

  vim.o.tabline = [[%!luaeval('require("ui.tabline.build")()')]]
  vim.o.showtabline = (config.start_hidden or config.auto_hide) and 0 or 2
end

return M
