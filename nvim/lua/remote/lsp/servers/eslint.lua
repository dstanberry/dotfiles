local M = {}

M.config = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(args)
        local diag = vim.diagnostic.get(args.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
        if #diag > 0 then vim.cmd "EslintFixAll" end
      end,
    })
  end,
}

return M
