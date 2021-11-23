local dap = require "remote.dap"
local util = require "util"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "netcoredbg")

local M = {}

M.setup = function(force)
  local install_cmd = [[
    curl -fLO https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz
    tar -xzvf netcoredbg-linux-amd64.tar.gz
    rm -vf netcoredbg-linux-amd64.tar.gz
  ]]
  util.terminal.install_package("netcoredbg", basedir, path, install_cmd, force)
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
