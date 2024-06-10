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

  local debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
  for _, adapter in ipairs(adapters) do
    dap.adapters[adapter] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          debugger_path .. "/js-debug/src/dapDebugServer.js",
          "${port}",
          "localhost",
        },
      },
    }
  end

  for _, language in ipairs(filetypes) do
    if not dap.configurations[language] then
      dap.configurations[language] = {
        {
          type = "pwa-node",
          name = "Launch file in new node process",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          name = "Attach to existing node process",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          name = "Launch in Chrome",
          request = "launch",
          preLaunchTask = "npm start",
          url = function()
            local c = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:4200",
              }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(c, url)
                end
              end)
            end)
          end,
          webRoot = "${workspaceFolder}",
          -- skipFiles = { "<node_internals>/**/*.js" },
          -- resolveSourceMapLocations = {
          --   "${workspaceFolder}/dist/**/*.js",
          --   "${workspaceFolder}/dist/*.js",
          -- },
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
