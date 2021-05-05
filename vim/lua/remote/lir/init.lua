---------------------------------------------------------------
-- => lir configuration
---------------------------------------------------------------
-- verify lir is available
local has_lir, lir = pcall(require, 'lir')
if not has_lir then
  return
end

local actions = require 'lir.actions'
local clipboard_actions = require 'lir.clipboard.actions'

lir.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l'] = actions.edit,
    ['<cr>'] = actions.edit,
    ['<c-s>'] = actions.split,
    ['<c-v>'] = actions.vsplit,
    ['<c-t>'] = actions.tabedit,

    ['h'] = actions.up,
    ['q'] = actions.quit,

    ['K'] = actions.mkdir,
    ['N'] = actions.newfile,
    ['R'] = actions.rename,
    ['@'] = actions.cd,
    ['Y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden,
    ['D'] = actions.delete,

    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste
  }
}

vim.api.nvim_set_keymap('n', '-', "<cmd>execute 'edit ' .. expand('%:h')<cr>",
                        {noremap = true})
