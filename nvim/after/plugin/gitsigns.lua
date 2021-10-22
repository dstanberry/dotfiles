-- verify gitsigns is available
local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

local c = require "ui.theme".colors
local groups = require "ui.theme.groups"
local map = require "util.map"

signs.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "▸", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = "▾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "▍", numhl = "GitSignsChangeNr" },
  },
  numhl = false,
  update_debounce = 1000,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
  },
}

map.nnoremap("]j", signs.next_hunk)
map.nnoremap("]k", signs.prev_hunk)
map.nnoremap("<leader>hs", signs.stage_hunk)
map.nnoremap("<leader>hu", signs.undo_stage_hunk)
map.nnoremap("<leader>hr", signs.reset_hunk)
map.nnoremap("<leader>hp", signs.preview_hunk)
map.nnoremap("<leader>hb", signs.toggle_current_line_blame)
map.nnoremap("<leader>gb", function()
  signs.blame_line(true)
end)

groups.new("GitSignsAdd", { guifg = c.base0B, guibg = c.base00, gui = nil, guisp = nil })
groups.new("GitSignsChange", { guifg = c.base0A, guibg = c.base00, gui = nil, guisp = nil })
groups.new("GitSignsDelete", { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil })
groups.new("GitSignsChangeDelete", { guifg = c.base09, guibg = c.base00, gui = nil, guisp = nil })
groups.new("GitSignsCurrentLineBlame", { guifg = c.base03, guibg = nil, gui = "italic", guisp = nil })
