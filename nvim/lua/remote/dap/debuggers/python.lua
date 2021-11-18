-- verify dap is available
local ok, dap_python = pcall(require, "dap-python")
if not ok then
  return
end

local dap = require "remote.dap"

local M = {}

M.setup = function()
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Debug Current File",
      program = "${file}",
      args = { "--target", "api" },
      console = "integratedTerminal",
    },
  }
  dap_python.setup("python", { include_configs = true })
  dap_python.test_runner = "pytest"
end

return M
