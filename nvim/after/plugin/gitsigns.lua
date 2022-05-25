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

groups.new("GitSignsAdd", { guifg = c.green, guibg = c.bg, gui = nil, guisp = nil })
groups.new("GitSignsChange", { guifg = c.yellow, guibg = c.bg, gui = nil, guisp = nil })
groups.new("GitSignsDelete", { guifg = c.red, guibg = c.bg, gui = nil, guisp = nil })
groups.new("GitSignsChangeDelete", { guifg = c.orange, guibg = c.bg, gui = nil, guisp = nil })
groups.new("GitSignsCurrentLineBlame", { guifg = c.gray_light, guibg = nil, gui = "italic", guisp = nil })
