local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = has "win32" and vim.fn.exepath "js-debug-adapter" or "js-debug-adapter",
      args = { "${port}" },
    },
  }
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      name = "Launch - node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach - node",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript
end

return M
