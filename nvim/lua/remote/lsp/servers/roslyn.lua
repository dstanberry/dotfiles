local M = {}

M.defer_setup = true

M.setup = function(opts)
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("lsp_dotnet", { clear = true }),
    pattern = { "cs", "vb" },
    callback = function()
      require("roslyn").setup {
        dotnet_cmd = "dotnet",
        capabilities = opts and opts.capabilities and opts.capabilities,
        on_attach = opts and opts.on_attach and opts.on_attach,
      }
    end,
  })
end

return M
