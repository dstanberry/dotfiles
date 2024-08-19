local html = require "ft.html"

local group = ds.augroup "html_extmarks"
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "ModeChanged" }, {
  group = group,
  pattern = "html",
  callback = vim.schedule_wrap(function(args)
    if
      package.loaded["nvim-treesitter"]
      and vim.api.nvim_get_mode().mode == "n"
      and vim.bo[args.buf].filetype == "html"
    then
      vim.opt_local.conceallevel = 2
      html.set_extmarks(args.buf)
    end
  end),
})
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  group = group,
  buffer = vim.api.nvim_get_current_buf(),
  callback = vim.schedule_wrap(function(args)
    vim.opt_local.conceallevel = 0
    html.disable_extmarks(args.buf, true)
  end),
})
