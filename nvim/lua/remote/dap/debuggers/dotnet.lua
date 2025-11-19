local M = {}

function M.setup()
  local dap = require "dap"

  dap.adapters.netcoredbg = {
    type = "executable",
    command = ds.plugin.get_pkg_path("netcoredbg", { exe = true }),
    args = { "--interpreter=vscode" },
    options = { detached = false },
  }
  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "Launch new process",
      request = "launch",
      program = function()
        return coroutine.create(function(_c)
          local root = ds.root.get()
          local dlls = {}
          ds.fs.walk(root, function(path, name, kind)
            if
              (kind == "file" or kind == "link")
              and path:match "/bin/Debug/"
              and name:match "%.dll$"
              and path:sub(1, -(#name + 2)):find(name:sub(1, -5), 1, true)
            then
              table.insert(dlls, path)
            end
          end)
          if #dlls == 1 then return coroutine.resume(_c, dlls[1]) end
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
  }
end

return M
