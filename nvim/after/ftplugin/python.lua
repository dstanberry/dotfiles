local python_concealer = require "ft.python.concealer"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CmdlineLeave", "InsertLeave" }, {
  group = "ftplugin",
  buffer = 0,
  callback = function()
    if package.loaded["nvim-treesitter"] then python_concealer.toggle_on() end
  end,
})
