local dap = require "remote.dap"

local M = {}

M.setup = function()
  dap.adapters.netcoredbg = {
    type = "executable",
    args = { "--interpreter=vscode" },
    command = "netcoredbg",
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
