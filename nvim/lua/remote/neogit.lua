local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NeogitNotificationInfo", { link = "String" })
groups.new("NeogitNotificationWarning", { link = "WarningMsg" })
groups.new("NeogitNotificationError", { link = "ErrorMsg" })

groups.new("NeogitBranch", { fg = c.green2 })
groups.new("NeogitRemote", { fg = c.red1 })
groups.new("NeogitHunkHeader", { bg = c.bg3 })
groups.new("NeogitHunkHeaderHighlight", { fg = c.blue2, bg = c.bg3 })
groups.new("NeogitDiffAddHighlight", { fg = c.green2, bg = c.diff_add })
groups.new("NeogitDiffDeleteHighlight", { fg = c.red1, bg = c.diff_delete })
groups.new("NeogitObjectId", { fg = c.yellow2 })

local ftplugin = vim.api.nvim_create_augroup("hl_neogit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "NeogitPopup", "NeogitStatus" },
  callback = function() vim.opt_local.winhighlight = "Normal:NormalSB" end,
})

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
