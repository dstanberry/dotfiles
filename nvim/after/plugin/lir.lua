-- verify lir is available
local ok, lir = pcall(require, "lir")
if not ok then
  return
end

local actions = require "lir.actions"
local has_mmv, mmv_actions = pcall(require "lir.mmv.actions")

lir.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ["l"] = actions.edit,
    ["<cr>"] = actions.edit,

    ["K"] = actions.mkdir,
    ["N"] = actions.newfile,
    ["R"] = actions.rename,
    ["Y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["D"] = actions.delete,

    ["M"] = (has_mmv and mmv_actions.mmv) or nil,
  },
}

require("lir.git_status").setup {
  show_ignored = false,
}

vim.api.nvim_set_keymap("n", "-", "<cmd>execute 'edit ' .. expand('%:h')<cr>", { noremap = true })
