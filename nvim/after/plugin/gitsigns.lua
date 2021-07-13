---------------------------------------------------------------
-- => gitsigns configuration
---------------------------------------------------------------
-- verify gitsigns is available
local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

-- default options
signs.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
  },
  numhl = false,
  keymaps = {
    noremap = true,
    buffer = true,
    ["n <space>hd"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
    ["n <space>hu"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
  },
}
