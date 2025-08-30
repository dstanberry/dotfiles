---@class remote.lsp.config
local M = {}

M.disabled = true

M.config = {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        reportMissingTypeStubs = false,
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

return M
