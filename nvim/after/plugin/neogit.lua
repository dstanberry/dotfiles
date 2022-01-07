-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

neogit.setup {
  disable_commit_confirmation = true,
  disable_context_highlighting = false,
  disable_insert_on_commit = false,
  commit_popup = {
    kind = "split",
  },
  signs = {
    hunk = { "", "" },
    item = { "", "" },
    section = { "", "" },
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

groups.new("NeogitObjectId", { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil })
