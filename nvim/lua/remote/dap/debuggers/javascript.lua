local path = vim.fn.expand(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local basedir = vim.fn.expand(("%s/%s"):format(path, "node-debug2-adapter"))

local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { ("%s/%s"):format(basedir, "out/src/nodeDebug.js") },
  }
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  }
end

return M
