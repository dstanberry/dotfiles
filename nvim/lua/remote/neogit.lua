local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NeogitNotificationInfo", { link = "String" })
groups.new("NeogitNotificationWarning", { link = "WarningMsg" })
groups.new("NeogitNotificationError", { link = "ErrorMsg" })

groups.new("NeogitBranch", { fg = c.green2 })
groups.new("NeogitRemote", { fg = c.red2 })
groups.new("NeogitHunkHeader", { fg = color.blend(c.blue4, c.bg2, 0.44), bg = color.blend(c.blue4, c.bg2, 0.05) })
groups.new("NeogitHunkHeaderHighlight", { fg = c.blue4, bg = color.blend(c.blue4, c.gray0, 0.1) })
groups.new("NeogitDiffContextHighlight", { fg = c.fg0, bg = c.gray0 })
groups.new("NeogitDiffAdd", { fg = c.green2, bg = c.diff_add })
groups.new("NeogitDiffAddHighlight", { fg = c.green2, bg = c.diff_add })
groups.new("NeogitDiffDeleteHighlight", { fg = c.red1, bg = c.diff_delete })
groups.new("NeogitObjectId", { fg = color.lighten(c.gray1, 20) })

return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
  keys = {
    { "<localleader>gs", function() require("neogit").open { kind = "tab" } end, desc = "neogit: open" },
    { "<localleader>gc", function() require("neogit").open { "commit" } end, desc = "neogit: commit" },
  },
  opts = {
    disable_commit_confirmation = true,
    disable_context_highlighting = false,
    disable_insert_on_commit = false,
    commit_popup = {
      kind = "tab",
    },
    signs = {
      hunk = { "", "" },
      item = { icons.misc.FoldClosed, icons.misc.FoldOpened },
      section = { icons.misc.DiagonalExpand, icons.misc.DiagonalShrink },
    },
    integrations = {
      diffview = true,
    },
  },
}
