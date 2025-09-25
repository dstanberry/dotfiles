if vim.g.vscode then return end

local group = ds.augroup "ftplugin.python"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "ModeChanged" }, {
  group = group,
  pattern = "*.py",
  callback = vim.schedule_wrap(function(args)
    if
      package.loaded["nvim-treesitter"]
      and vim.api.nvim_get_mode().mode == "n"
      and vim.bo[args.buf].filetype == "python"
    then
      ds.ft.python.set_extmarks(args.buf)
    end
  end),
})

vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  group = group,
  pattern = "*.py",
  callback = vim.schedule_wrap(function(args) ds.ft.python.reset_extmarks(args.buf, true) end),
})
