local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NeogitBranch", { fg = c.green })
groups.new("NeogitRemote", { fg = c.red })
groups.new("NeogitHunkHeader", { bg = c.bg_highlight })
groups.new("NeogitHunkHeaderHighlight", { fg = c.blue, bg = c.bg_light })
groups.new("NeogitDiffAddHighlight", { fg = c.green, bg = c.diff_add })
groups.new("NeogitDiffDeleteHighlight", { fg = c.red, bg = c.diff_delete })
groups.new("NeogitObjectId", { fg = c.yellow })

return {
  "TimUntersberger/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
  keys = {
    { "<localleader>gs", function() require("neogit").open { kind = "split" } end, desc = "neogit: open" },
    { "<localleader>gc", function() require("neogit").open { "commit" } end, desc = "neogit: commit" },
  },
  opts = {
    disable_commit_confirmation = true,
    disable_context_highlighting = false,
    disable_insert_on_commit = false,
    commit_popup = {
      kind = "split",
    },
    signs = {
      hunk = { "", "" },
      item = { icons.misc.FoldClosed, icons.misc.FoldOpened },
      section = { icons.misc.FoldClosed, icons.misc.FoldOpened },
    },
    integrations = {
      diffview = true,
    },
  },
}
