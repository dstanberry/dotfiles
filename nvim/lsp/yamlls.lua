---@class remote.lsp.config
local M = {}

M.config = {
  on_new_config = function(new_config)
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
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
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
}

return M
