---------------------------------------------------------------
-- => nvim-autopairs
---------------------------------------------------------------
-- verify nvim-autopoirs is available
local has_autopairs, autopairs = pcall(require, 'nvim-autopairs')
if not has_autopairs then
  return
end

vim.g.completion_confirm_key = ""
_G.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return autopairs.esc("<c-y>")
    else
      vim.defer_fn(function() vim.fn["compe#confirm"]("<cr>") end, 20)
      return autopairs.esc("<c-n>")
    end
  else
    return autopairs.check_break_line_char()
  end
end

vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.completion_confirm()',
      {expr = true, noremap = true})

-- disable autopairs in telescope windows
require('nvim-autopairs').setup({disable_filetype = {"TelescopePrompt"}})
