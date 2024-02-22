local util = require "util"

local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.chrome = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        vim.fs.normalize(vim.fn.stdpath "data" .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js"),
        "${port}",
      },
    },
  }

  local languages = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }

  vim.keymap.set("n", "<leader>da", function()
    local root = util.buffer.get_root()
    if vim.loop.fs_stat(root .. "/.vscode/launch.json") then
      require("dap.ext.vscode").load_launchjs(nil, {
        chrome = languages,
        ["pwa-chrome"] = languages,
        ["pwa-node"] = languages,
      })
    end
    require("dap").continue()
  end, { desc = "dap: run with args" })

  for _, language in ipairs(languages) do
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
          preLaunchTask = "npm run start",
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
