-- verify gitsigns is available
local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

signs.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = icons.misc.VerticalBarThin },
    change = { hl = "GitSignsChange", text = icons.misc.VerticalBarThin },
    delete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
    topdelete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
    changedelete = { hl = "GitSignsDelete", text = icons.misc.VerticalBar },
  },
  numhl = false,
  update_debounce = 1000,
  current_line_blame = false,
  current_line_blame_formatter = icons.git.Commit .. " <author>, <author_time:%R>",
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 150,
  },
}

vim.keymap.set("n", "]j", signs.next_hunk)
vim.keymap.set("n", "]k", signs.prev_hunk)
vim.keymap.set("n", "<leader>hs", signs.stage_hunk)
vim.keymap.set("n", "<leader>hu", signs.undo_stage_hunk)
vim.keymap.set("n", "<leader>hr", signs.reset_hunk)
vim.keymap.set("n", "<leader>hp", signs.preview_hunk)
vim.keymap.set("n", "<leader>hb", signs.toggle_current_line_blame)
vim.keymap.set("n", "<leader>gb", function()
  signs.blame_line(true)
end)

groups.new("GitSignsAdd", { fg = c.green, bg = c.bg })
groups.new("GitSignsChange", { fg = c.yellow, bg = c.bg })
groups.new("GitSignsDelete", { fg = c.red, bg = c.bg })
groups.new("GitSignsChangeDelete", { fg = c.orange, bg = c.bg })
groups.new("GitSignsCurrentLineBlame", { fg = c.gray_light, italic = true })
