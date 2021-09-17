-- verify gitsigns is available
local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

signs.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "▸", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = "▾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "▍", numhl = "GitSignsChangeNr" },
  },
  numhl = false,
  keymaps = {
    noremap = true,
    buffer = true,
    ["n ]j"] = { expr = true, [[&diff ? ']c' : '<cmd>lua require("gitsigns").next_hunk()<cr>']] },
    ["n ]k"] = { expr = true,[["&diff ? '[c' : '<cmd>lua require("gitsigns").prev_hunk()<cr>']] },
    ["n <leader>hs"] = [[<cmd>lua require("gitsigns").stage_hunk()<cr>]],
    ["v <leader>hs"] = [[<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>]],
    ["n <leader>hu"] = [[<cmd>lua require("gitsigns").undo_stage_hunk()<cr>',
    ["n <leader>hr"] = [[<cmd>lua require("gitsigns").reset_hunk()<cr>',
    ["v <leader>hr"] = [[<cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>]],
    ["n <leader>hR"] = [[<cmd>lua require("gitsigns").reset_buffer()<cr>]],
    ["n <leader>hp"] = [[<cmd>lua require("gitsigns").preview_hunk()<cr>]],
    ["n <leader>hb"] = [[<cmd>lua require("gitsigns").blame_line(true)<cr>]],
  },
  update_debounce = 1000,
}
