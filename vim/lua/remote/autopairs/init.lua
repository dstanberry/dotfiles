---------------------------------------------------------------
-- => nvim-autopairs
---------------------------------------------------------------
-- verify nvim-autopoirs is available
local has_autopairs, autopairs = pcall(require, 'nvim-autopairs')
if not has_autopairs then
  return
end

_G.MUtils = {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm = function()
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

vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.completion_confirm()',
      {expr = true, noremap = true})

require('nvim-autopairs').setup({disable_filetype = {"TelescopePrompt"}})
