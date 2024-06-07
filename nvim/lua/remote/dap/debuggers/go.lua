local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = ds.has "win32" and vim.fn.exepath "dlv" or "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }
  dap.configurations.go = {
    {
      type = "delve",
      name = "Launch - delve",
      request = "launch",
      program = "${file}",
      console = "integratedTerminal",
    },
    {
      type = "delve",
      name = "Launch - delve [test]",
      request = "launch",
      mode = "test",
      program = "${file}",
      console = "integratedTerminal",
    },
    {
      type = "delve",
      name = "Launch - delve [test (go.mod)]",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
      console = "integratedTerminal",
    },
  }
end

return M
