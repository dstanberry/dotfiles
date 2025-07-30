if vim.g.vscode then return end

local group = ds.augroup "html_extmarks"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "ModeChanged" }, {
  group = group,
  pattern = "*.html",
  callback = vim.schedule_wrap(function(args)
    if
      package.loaded["nvim-treesitter"]
      and vim.api.nvim_get_mode().mode == "n"
      and vim.bo[args.buf].filetype == "html"
    then
      vim.opt_local.conceallevel = 2
      ds.ft.html.set_extmarks(args.buf)
    end
  end),
})
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  group = group,
  pattern = "*.html",
  callback = vim.schedule_wrap(function(args)
    vim.opt_local.conceallevel = 0
    ds.ft.html.reset_extmarks(args.buf, true)
  end),
})
