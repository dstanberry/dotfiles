---@class remote.lsp.config
local M = {}

M.config = {
  on_attach = function(_, bufnr)
    if vim.bo[bufnr].filetype == "helm" then vim.schedule(function() vim.cmd "LspStop ++force yamlls" end) end
  end,
  capabilities = {
    textDocument = {
      foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
    },
  },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      schemas = require("schemastore").yaml.schemas(),
      schemaStore = { enable = false, url = "" },
      validate = true,
    },
  },
}

return M
