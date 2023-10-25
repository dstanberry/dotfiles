local c = require("ui.theme").colors
local color = require "util.color"

return {
  "folke/todo-comments.nvim",
  cmd = { "TodoQuickFix", "TodoTelescope", "TodoTrouble" },
  event = "LazyFile",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    sign_priority = 0,
    colors = {
      error = { color.blend(c.red1, c.gray1, 0.31) },
      warning = { color.blend(c.yellow2, c.gray1, 0.31) },
      info = { color.blend(c.aqua1, c.gray1, 0.31) },
      hint = { color.blend(c.magenta1, c.gray1, 0.31) },
      default = { color.blend(c.blue0, c.gray1, 0.31) },
      test = { color.blend(c.green0, c.gray1, 0.31) },
    },
  },
}
