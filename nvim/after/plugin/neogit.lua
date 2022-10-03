-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

neogit.setup {
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
}

vim.keymap.set("n", "<leader>gs", function()
  neogit.open { kind = "split" }
end)

vim.keymap.set("n", "<leader>gc", function()
  neogit.open { "commit" }
end)

groups.new("NeogitBranch", { fg = c.green })
groups.new("NeogitRemote", { fg = c.red })
groups.new("NeogitHunkHeader", { bg = c.bg_highlight })
groups.new("NeogitHunkHeaderHighlight", { fg = c.blue, bg = c.bg_light })
groups.new("NeogitDiffAddHighlight", { fg = c.green, bg = c.diff_add })
groups.new("NeogitDiffDeleteHighlight", { fg = c.red, bg = c.diff_delete })
groups.new("NeogitObjectId", { fg = c.yellow })
