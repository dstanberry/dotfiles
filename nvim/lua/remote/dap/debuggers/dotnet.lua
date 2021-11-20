local dap = require "remote.dap"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "netcoredbg")

local bootstrap = function()
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    vim.fn.mkdir(path, "p")
    print "Installing netcoredbg..."
    local out = vim.fn.system(string.format(
      [[cd %s
      curl -fLO https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz
      tar -xzvf netcoredbg-linux-amd64.tar.gz
      rm -vf netcoredbg-linux-amd64.tar.gz
      ]],
      vim.fn.expand(path)
    ))
    print(out)
  end
end

local M = {}

M.setup = function()
  bootstrap()
  dap.adapters.netcoredbg = {
    type = "executable",
    args = { "--interpreter=vscode" },
    command = vim.fn.expand(("%s/%s"):format(basedir, "netcoredbg")),
  }
  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to dll", vim.fn.expand(vim.fn.getcwd() .. "/bin/Debug/"), "file")
      end,
      stopAtEntry = true,
    },
  }
end

return M
