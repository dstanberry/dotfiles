local c = require("ui.theme").colors
local color = require "util.color"

return {
  "folke/todo-comments.nvim",
  cmd = { "TodoQuickFix", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    sign_priority = 0,
    colors = {
      error = { color.blend(c.red1, c.gray1, "50") },
      warning = { color.blend(c.yellow2, c.gray1, "50") },
      info = { color.blend(c.aqua1, c.gray1, "50") },
      hint = { color.blend(c.magenta1, c.gray1, "50") },
      default = { color.blend(c.blue0, c.gray1, "50") },
      test = { color.blend(c.green0, c.gray1, "50") },
    },
  },
}
