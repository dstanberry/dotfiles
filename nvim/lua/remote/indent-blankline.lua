local icons = require "ui.icons"

return { 
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    indentLine_enabled = 1,
    show_current_context = false,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
    space_char_blankline = " ",
    char_list = { icons.misc.VerticalBarThin, icons.misc.VerticalBarSplit },
    buftype_exclude = { "terminal" },
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
