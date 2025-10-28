---@class remote.lsp.config
local M = { disabled = true }

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

return function() return M end
