local path = vim.fs.normalize(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local basedir = vim.fs.normalize(("%s/%s"):format(path, "node-debug2-adapter"))

local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.node2 = {
    type = "executable",
    command = has "win32" and vim.fn.exepath "node" or "node",
    args = { ("%s/%s"):format(basedir, "out/src/nodeDebug.js") },
  }
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/${file}",
      cwd = vim.loop.cwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  }
end

return M
