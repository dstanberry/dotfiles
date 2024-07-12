local M = {}

M.setup = function()
  local dap = require "dap"
  local vscode = require "dap.ext.vscode"

  local adapters = { "chrome", "node", "pwa-chrome", "pwa-node" }
  local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

  vscode.type_to_filetypes["chrome"] = filetypes
  vscode.type_to_filetypes["node"] = filetypes
  vscode.type_to_filetypes["pwa-chrome"] = filetypes
  vscode.type_to_filetypes["pwa-node"] = filetypes

  for _, adapter in ipairs(adapters) do
    dap.adapters[adapter] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          ds.plugin.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
          "${port}",
        },
      },
    }
  end

  for _, language in ipairs(filetypes) do
    if not dap.configurations[language] then
      dap.configurations[language] = {
        {
          type = "pwa-node",
          name = "Launch new process (node)",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          name = "Attach to existing process (node)",
          request = "attach",
          processId = function(opts)
            opts = opts or {}
            local procs = require("dap.utils").get_processes()
            return coroutine.create(function(_c)
              vim.ui.select(
                procs,
                { prompt = "Select process:", format_item = function(item) return item.name end },
                function(choice)
                  coroutine.resume(_c, (choice and choice.pid and choice.pid > 0) and choice.pid or dap.ABORT)
                end
              )
            end)
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          name = "Launch new process (chrome)",
          request = "launch",
          preLaunchTask = "npm start",
          url = function()
            return coroutine.create(function(_c)
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:4200",
              }, function(url) coroutine.resume(_c, (url and url ~= "") and url or dap.ABORT) end)
            end)
          end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          userDataDir = false,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }
    end
  end
end

return M
