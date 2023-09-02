local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        require("mason-registry").get_package("js-debug-adapter"):get_install_path()
          .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
  for _, language in ipairs { "typescript", "javascript" } do
    if not dap.configurations[language] then
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to existing node process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        language == "javascript" and {
          type = "pwa-node",
          name = "Launch file in new node process",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        } or nil,
      }
    end
  end
end

return M
