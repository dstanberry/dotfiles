---------------------------------------------------------------
-- => nvim-compe mappings
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, "compe") then
  return
end

local opts = { noremap = true, expr = true, silent = true }

vim.api.nvim_set_keymap("i", "<cr>", "compe#confirm('<cr>')", opts)
vim.api.nvim_set_keymap("i", "<esc>", "compe#close('<esc>')", opts)
vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()", opts)
