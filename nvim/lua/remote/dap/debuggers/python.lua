local M = {}

M.setup = function(cmd)
  -- verify dap is available
  local ok, dap_python = pcall(require, "dap-python")
  if not ok then
    return
  end

  local dap = require "dap"

  cmd = cmd or "python"
  dap.configurations.python = {}
  dap_python.setup(cmd, {
    include_configs = true,
    pythonPath = cmd,
    console = "integratedTerminal",
  })
  dap_python.test_runner = "pytest"
end

return M
