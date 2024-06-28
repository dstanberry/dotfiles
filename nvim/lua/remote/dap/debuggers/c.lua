local path = string.format("%s/mason/packages", vim.fn.stdpath "data")
local basedir = vim.fs.normalize(("%s/%s"):format(path, "codelldb"))
local bin = vim.fs.normalize(("%s/%s"):format(basedir, "extension/adapter/codelldb"))
local lib = vim.fs.normalize(("%s/%s"):format(basedir, "extension/lldb/lib/liblldb.so"))

local M = {}

M.get_executable_path = function()
  return {
    code = bin,
    library = lib,
  }
end

M.setup = function()
  local dap = require "dap"
  local vscode = require "dap.ext.vscode"

  vscode.type_to_filetypes["codelldb"] = { "c", "cpp", "rust" }

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = bin,
      args = { "--port", "${port}" },
      detached = ds.has "win32" and false or nil,
    },
  }
  dap.configurations.c = {
    {
      type = "codelldb",
      name = "Launch new process",
      request = "launch",
      program = function()
        return coroutine.create(function(_c)
          local root = ds.buffer.get_root()
          local targets = {}
          ds.walk(root, function(_path, _, type)
            if (type == "file" or type == "link") and _path:match "/target/debug/" then table.insert(targets, _path) end
          end)
          if #targets == 1 then return coroutine.resume(_c, targets[1]) end
          vim.ui.select(
            targets,
            { prompt = "Select executable target:", format_item = function(item) return item:match ".*/(.-)$" end },
            function(choice) coroutine.resume(_c, (choice and choice ~= "") and choice or dap.ABORT) end
          )
        end)
      end,
      cwd = "${workspaceFolder}",
      args = {},
      stopOnEntry = true,
      console = "integratedTerminal",
    },
  }
  dap.configurations.cpp = dap.configurations.c
  dap.configurations.rust = dap.configurations.c
end

return M
