local M = {}

M.config = {
  settings = {
    workingDirectory = { mode = "auto" },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
}

return M
