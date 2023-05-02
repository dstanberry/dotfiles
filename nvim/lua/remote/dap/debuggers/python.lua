local M = {}

M.setup = function()
  -- verify dap is available
  local ok, dap_python = pcall(require, "dap-python")
  if not ok then return end

  local dap = require "dap"

  local cmd = has "win32" and vim.fn.exepath "python" or "python"
  dap.configurations.python = {}
  dap_python.setup(cmd, {
    include_configs = true,
    pythonPath = cmd,
    console = "integratedTerminal",
  })
  dap_python.test_runner = "pytest"
end

return M
