local M = {}

M.config = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(args)
        local client = vim.lsp.get_clients({ bufnr = args.buf, name = "eslint" })[1]
        if client then
          local diag = vim.diagnostic.get(args.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
          if #diag > 0 then vim.cmd "EslintFixAll" end
        end
      end,
    })
  end,
}

return M
