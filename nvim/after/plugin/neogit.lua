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

groups.new("NeogitHunkHeader", { bg = c.bg_light })
groups.new("NeogitHunkHeaderHighlight", { fg = c.blue, bg = c.bg_light })
groups.new("NeogitObjectId", { fg = c.yellow })
