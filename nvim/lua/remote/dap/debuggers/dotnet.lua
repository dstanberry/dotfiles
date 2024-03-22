local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.netcoredbg = {
    type = "executable",
    args = { "--interpreter=vscode" },
    command = has "win32" and vim.fn.exepath "netcoredbg" or "netcoredbg",
  }
  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "Launch - netcoredbg",
      request = "launch",
      program = function() return vim.fn.input("Path to dll", vim.fs.normalize(vim.uv.cwd() .. "/bin/Debug/"), "file") end,
      stopAtEntry = true,
      console = "integratedTerminal",
    },
  }
end

return M
