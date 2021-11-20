local dap = require "remote.dap"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "vscode-node-debug2")

local bootstrap = function()
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    vim.fn.mkdir(path, "p")
    print "Installing vscode-node-debug2..."
    local out = vim.fn.system(string.format(
      [[cd %s
      git clone https://github.com/microsoft/vscode-node-debug2.git && cd vscode-node-debug2
      npm install
      npm run build
      ]],
      vim.fn.expand(path)
    ))
    print(out)
  end
end

local M = {}

M.setup = function()
  bootstrap()
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
