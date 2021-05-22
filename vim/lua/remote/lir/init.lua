---------------------------------------------------------------
-- => lir configuration
---------------------------------------------------------------
-- verify lir is available
local has_lir, lir = pcall(require, 'lir')
if not has_lir then
  return
end

local actions = require 'lir.actions'

lir.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l'] = actions.edit,
    ['<cr>'] = actions.edit,

    ['K'] = actions.mkdir,
    ['N'] = actions.newfile,
    ['R'] = actions.rename,
    ['Y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden,
    ['D'] = actions.delete
  }
}

vim.api.nvim_set_keymap("n", "-",
                        "<cmd>execute 'edit ' .. expand('%:h')<cr>",
                        {noremap = true})
