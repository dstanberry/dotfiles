local M = {}

M.setup = function()
  local dap = require "dap"

  local ok, dap_vscode = pcall(require, "dap-vscode-js")

  local debugger = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
    .. "/js-debug/src/dapDebugServer.js"

  if ok then
    ---@diagnostic disable-next-line: missing-fields
    dap_vscode.setup {
      adapters = { "pwa-node", "pwa-chrome" },
      debugger_executable = debugger,
    }
  else
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { debugger, "${port}" },
      },
    }
  end

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
        {
          type = "pwa-node",
          name = "Launch file in new node process",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Launch in Chrome",
          type = "pwa-chrome",
          request = "launch",
          preLaunchTask = "npm run start",
          url = "https://localhost:4200",
          webRoot = "${workspaceFolder}",
          resolveSourceMapLocations = {
            "${workspaceFolder}/dist/**/*.js",
            "${workspaceFolder}/dist/*.js",
          },
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }
    end
  end
end

return M
