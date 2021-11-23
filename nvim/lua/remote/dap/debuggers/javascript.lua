local dap = require "remote.dap"
local util = require "util"

local path = vim.fn.expand(string.format("%s/dap", vim.fn.stdpath "data"))
local basedir = vim.fn.expand(("%s/%s"):format(path, "vscode-node-debug2"))

local M = {}

M.setup = function(force)
  local install_cmd = [[
    git clone https://github.com/microsoft/vscode-node-debug2.git
    cd vscode-node-debug2
    npm install
    npm run build
  ]]
  util.terminal.install_package("vscode-node-debug2", basedir, path, install_cmd, force)
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
