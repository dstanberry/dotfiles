-- verify lir is available
local ok, lir = pcall(require, "lir")
if not ok then
  return
end

local actions = require "lir.actions"
local git_status = require("lir.git_status")
local has_mmv, mmv_actions = pcall(require "lir.mmv.actions")
local map = require "util.map"

lir.setup {
  devicons_enable = true,
  hide_cursor = true,
  show_hidden_files = false,
  mappings = {
    ["."] = actions.toggle_show_hidden,
    [".."] = actions.up,
    ["<c-t>"] = actions.tabedit,
    ["<c-v>"] = actions.vsplit,
    ["<c-x>"] = actions.split,
    ["<cr>"] = actions.edit,
    ["dd"] = actions.delete,
    ["M"] = actions.mkdir,
    ["N"] = actions.newfile,
    ["R"] = has_mmv and mmv_actions.mmv or nil,
    ["r"] = actions.rename,
    ["Y"] = actions.yank_path,
  },
}

git_status.setup {
  show_ignored = true,
}

map.nnoremap("-", function()
  local path = vim.fn.expand "%:h"
  return map.t(("<cmd>edit %s<cr>"):format(path))
end, {
  expr = true,
})
