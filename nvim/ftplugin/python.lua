local python = require "ft.python"

local group = ds.augroup "python_extmarks"
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "ModeChanged" }, {
  group = group,
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
  group = group,
  buffer = vim.api.nvim_get_current_buf(),
  callback = vim.schedule_wrap(function(args) python.disable_extmarks(args.buf, true) end),
})
