local icons = require "ui.icons"

require("ui.statusline").setup {
  disabled_filetypes = {
    "DiffviewFiles",
    "gitcommit",
    "help",
    "lazy",
    "lir",
    "NeogitPopup",
    "NeogitStatus",
    "qf",
    "startuptime",
    "TelescopePrompt",
    "toggleterm",
  },
  separators = {
    left = { hl = "user9", symbol = " " },
    -- right = { hl = "user9", symbol = " " },
    right = { hl = "user9", symbol = " " },
  },
  sections = {
    left = {
      { modehl = icons.misc.VerticalBarBold },
      { modehl = "git_branch" },
      { user7 = "diagnostics" },
      { user7 = "git_diff" },
      { user7 = "git_blame" },
    },
    right = {
      { user7 = { "cursor", padding = { left = 0, right = 1 } } },
      { user7 = { "indent", padding = { left = 1, right = 1 } } },
      { user7 = { "encoding", padding = { left = 1, right = 1 } } },
      { user7 = "fileformat" },
      { user7 = { "filetype", text_only = true } },
    },
  },
  winbar = {
    left = {
      { "breadcrumbs" },
    },
  },
}
