local python = require "ft.python"

local py_extmarks = vim.api.nvim_create_augroup("md_extmarks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "ModeChanged" }, {
  group = py_extmarks,
  buffer = vim.api.nvim_get_current_buf(),
  callback = vim.schedule_wrap(function(args)
    if
      package.loaded["nvim-treesitter"]
      and vim.api.nvim_get_mode().mode == "n"
      and vim.bo[args.buf].filetype == "python"
    then
      python.set_extmarks(args.buf)
    end
  end),
})
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  group = py_extmarks,
  buffer = vim.api.nvim_get_current_buf(),
  callback = vim.schedule_wrap(function(args) python.disable_extmarks(args.buf, true) end),
})
