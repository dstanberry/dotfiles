local M = {}

M.setup = function()
  local dap = require "dap"

  dap.adapters.coreclr = {
    type = "executable",
    args = { "--interpreter=vscode" },
    command = ds.has "win32" and vim.fn.exepath "netcoredbg" or "netcoredbg",
  }
  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "Launch new process",
      request = "launch",
      program = function()
        return coroutine.create(function(_c)
          local root = ds.buffer.get_root()
          local dlls = {}
          ds.walk(root, function(path, name, type)
            if (type == "file" or type == "link") and path:match "/bin/Debug/" and name:match "%.dll$" then
              table.insert(dlls, path)
            end
          end)
          vim.ui.select(
            dlls,
            { prompt = "Select .NET target:", format_item = function(item) return item:match ".*/(.-)%.dll$" end },
            function(choice) coroutine.resume(_c, (choice and choice ~= "") and choice or dap.ABORT) end
          )
        end)
      end,
      env = { ASPNETCORE_ENVIRONMENT = "Development" },
      stopAtEntry = false,
    },
    {
      type = "coreclr",
      name = "Attach to existing process",
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
    },
  }
end

return M
