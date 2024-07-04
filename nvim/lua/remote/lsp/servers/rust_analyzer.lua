local M = {}

M.config = {
  settings = {
    ["rust-analyzer"] = {
      assist = { importGranularity = "module", importPrefix = "by_self" },
      cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
      checkOnSave = { enable = true, command = "clippy" },
      experimental = { procAttrMacros = true },
      hoverActions = { references = true },
      inlayHints = { enable = true },
      lens = { enable = true, methodReferences = true, references = true },
      procMacro = { enable = true },
    },
  },
}

M.defer_setup = true

return M
