-- verify go is available
local ok, go = pcall(require, "go")
if not ok then
  return
end

go.setup {
  dap_debug = true,
  dap_debug_gui = true,
  dap_debug_keymap = false,
  dap_debug_vt = true,
  gopls_cmd = nil,
  lsp_cfg = false,
  lsp_codelens = true,
  lsp_gofumpt = false,
  lsp_on_attach = false,
  verbose = false,
}

local M = {}

M.config = {
  -- vim.cmd [[
  --   highlight! default link LspCodeLens NONE
  --   highlight! default link LspCodeLensText NONE
  --   highlight! default link LspCodeLensTextSign NONE
  --   highlight! default link LspCodeLensTextSeparator NONE
  -- ]],
}

return M
