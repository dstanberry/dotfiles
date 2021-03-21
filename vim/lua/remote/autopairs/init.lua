---------------------------------------------------------------
-- => nvim-autopairs
---------------------------------------------------------------
-- verify nvim-autopoirs is available
local has_autopairs, autopairs = pcall(require, 'nvim-autopairs')
if not has_autopairs then
  return
end

_G.MUtils= {}

MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return autopairs.esc("<c-y>")
    else
      vim.fn.nvim_select_popupmenu_item(0 , false , false ,{})
      require'completion'.confirmCompletion()
      return autopairs.esc("<c-n><c-y>")
    end
  else
    return autopairs.check_break_line_char()
  end
end

local remap = vim.api.nvim_set_keymap
remap('i' , '<cr>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})

require('nvim-autopairs').setup({
  disable_filetype = {"TelescopePrompt"},
})
