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

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = bin,
      args = { "--port", "${port}" },
      detached = has "win32" and false or nil,
    },
  }
  dap.configurations.c = {
    {
      type = "codelldb",
      name = "Launch - codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fs.normalize(vim.loop.cwd() .. "/target/debug/"), "file")
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
