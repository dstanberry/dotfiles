-- verify lua-dev is available
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

-- require("util").define_augroup {
--   name = "rust_show_line_hints",
--   clear = true,
--   autocmds = {
--     {
--       event = { "CursorHold", "CursorHoldI" },
--       pattern = "*.rs",
--       callback = M.show_inlay_hints,
--     },
--   },
-- }

return M
