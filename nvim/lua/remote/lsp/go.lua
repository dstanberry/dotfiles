-- verify go is available
local ok, go = pcall(require, "go")
if not ok then
  return
end

go.setup {
  verbose = false,
  dap_debug = true,
  dap_debug_keymap = false,
  dap_debug_gui = true,
  dap_debug_vt = true,
  lsp_cfg = false,
  lsp_gofumpt = false,
  lsp_on_attach = false,
  gopls_cmd = nil,
}