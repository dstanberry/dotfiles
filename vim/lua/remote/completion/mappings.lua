---------------------------------------------------------------
-- => nvim-compe mappings
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, 'compe') then
  return
end

vim.api.nvim_set_keymap("i", "<cr>", "compe#confirm('<cr>')",
                        {noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<esc>", "compe#close('<esc>')",
                        {noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()",
                        {noremap = true, expr = true, silent = true})
