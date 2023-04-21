local excludes = require("ui.excludes")
local icons = require "ui.icons"

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indentLine_enabled = 1,
    show_current_context = false,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
    space_char_blankline = " ",
    char_list = { icons.misc.VerticalBarThin, icons.misc.VerticalBarSplit },
    buftype_exclude = excludes.bt.wb_disabled,
    filetype = {
      "go",
      "html",
      "json",
      "ps1",
      "python",
      "rust",
    },
  },
}
