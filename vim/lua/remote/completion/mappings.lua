---------------------------------------------------------------
-- => nvim-compe mappings
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, 'compe') then
  return
end

vim.api.nvim_set_keymap("i", "<cr>", "v:lua.compe_confirm()",
                        {noremap = true, expr = true, silent = true})

vim.api.nvim_set_keymap("i", "<esc>", "v:lua.compe_close()",
                        {noremap = true, expr = true, silent = true})

vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()",
                        {noremap = true, expr = true, silent = true})
