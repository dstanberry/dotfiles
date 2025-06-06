---@class remote.lsp.config
local M = {}

M.config = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)
    local _fix = function()
      local diag = vim.diagnostic.get(bufnr, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
      if #diag > 0 then vim.cmd "EslintFixAll" end
    end
    vim.keymap.set("n", "<leader>lF", _fix, { buffer = bufnr, desc = "eslint: fix all problems" })
  end,
}

return M
