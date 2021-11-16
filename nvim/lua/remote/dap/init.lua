-- verify dap is available
local ok, _ = pcall(require, "dap")
if not ok then
  return
end

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "LspDiagnosticsSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "LspDiagnosticsDefaultWarning",
  linehl = "LspDiagnosticsDefaultWarning",
  numhl = "",
})

if pcall(require, "nvim-dap-virtual-text") then
  vim.g.dap_virtual_text = true
end

local dap_install
ok, dap_install = pcall(require, "dap-install")
if not ok then
  return
end

local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

dap_install.setup {
  installation_path = string.format("%s/dap/", vim.fn.stdpath "data"),
}

for _, debugger in ipairs(dbg_list) do
  dap_install.config(debugger)
end
