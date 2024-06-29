local python = require "ft.python"

local py_extmarks = vim.api.nvim_create_augroup("md_extmarks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CmdlineLeave", "InsertLeave" }, {
  group = py_extmarks,
  buffer = 0,
  callback = function()
    if package.loaded["nvim-treesitter"] then python.set_extmarks() end
  end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = py_extmarks,
  buffer = 0,
  callback = function() python.disable_extmarks(true) end,
})
