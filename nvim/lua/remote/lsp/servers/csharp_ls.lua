local M = {}

M.config = {
  handlers = {
    ["textDocument/definition"] = function(...) return require("csharpls_extended").handler(...) end,
    ["textDocument/typeDefinition"] = function(...) return require("csharpls_extended").handler(...) end,
  },
}

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = ds.augroup "lsp_csharpls",
    pattern = "cs",
    callback = function(args)
      if not (args.data and args.data.client_id) then return end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "csharp_ls" then
        vim.keymap.set(
          "n",
          "gd",
          function() require("csharpls_extended").lsp_definitions() end,
          { buffer = args.buf or vim.api.nvim_get_current_buf(), desc = "csharp: goto definition" }
        )
      end
    end,
  })
end

return M
