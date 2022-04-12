-- verify lsp_extensions is available
local ok, inlay_hints = pcall(require, "lsp_extensions.inlay_hints")
if not ok then
  return
end

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

M.show_inlay_hints = function()
  vim.lsp.buf_request(
    0,
    "rust-analyzer/inlayHints",
    inlay_hints.get_params(),
    inlay_hints.get_callback {
      highlight = "LspCodeLensText",
      prefix = "  ",
      only_current_line = false,
      enabled = { "TypeHint", "ChainingHint", "ParameterHint" },
    }
  )
end

-- vim.api.nvim_create_augroup("rust_show_line_hints", {clear = true })

-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   group = "rust_show_line_hints",
--   pattern = "*.rs",
--   callback = M.show_inlay_hints,
-- })

return M
