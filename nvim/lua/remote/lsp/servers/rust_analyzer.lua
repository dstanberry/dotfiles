local M = {}

M.config = {
  settings = {
    ["rust-analyzer"] = {
      assist = { importGranularity = "module", importPrefix = "by_self" },
      cargo = { loadOutDirsFromCheck = true, allFeatures = true },
      checkOnSave = { command = "clippy" },
      experimental = { procAttrMacros = true },
      hoverActions = { references = true },
      inlayHints = { enable = true },
      lens = { methodReferences = true, references = true },
      procMacro = { enable = true },
    },
  },
}

return M
