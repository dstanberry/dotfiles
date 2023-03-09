local c = require("ui.theme").colors
local icons = require "ui.icons"

reload("ui.statusline").setup {
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
    left = { component = " ", highlight = { fg = c.gray_dark, bg = c.gray } },
    right = { component = " ", highlight = { fg = c.gray_dark, bg = c.gray } },
  },
  sections = {
    left = {
      { component = icons.misc.VerticalBarBold, highlight = "mode" },
      { component = "git_branch", highlight = "mode" },
      { component = "diagnostics", highlight = { fg = c.white, bg = c.gray } },
      { component = "git_diff", highlight = { fg = c.white, bg = c.gray } },
      { component = "git_blame", highlight = { fg = c.white, bg = c.gray } },
    },
    right = {
      {
        component = "cursor",
        highlight = { fg = c.white, bg = c.gray },
        opts = { padding = { left = 0, right = 1 } },
      },
      {
        component = "indent",
        highlight = { fg = c.white, bg = c.gray },
        opts = { padding = { left = 1, right = 1 } },
      },
      {
        component = "encoding",
        highlight = { fg = c.white, bg = c.gray },
        opts = { padding = { left = 1, right = 1 } },
      },
      {
        component = "fileformat",
        highlight = { fg = c.white, bg = c.gray },
      },
      {
        component = "filetype",
        highlight = { fg = c.white, bg = c.gray },
        opts = { text_only = true },
      },
    },
  },
  winbar = {
    left = { component = "breadcrumbs" },
  },
}
