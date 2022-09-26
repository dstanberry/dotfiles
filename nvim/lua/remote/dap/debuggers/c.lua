local dap = require "remote.dap"
local util = require "util"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = vim.fn.expand(("%s/%s"):format(path, "codelldb"))
local bin = vim.fn.expand(("%s/%s"):format(basedir, "extension/adapter/codelldb"))
local lib = vim.fn.expand(("%s/%s"):format(basedir, "extension/lldb/lib/liblldb.so"))

local M = {}

M.get_executable_path = function()
  return {
    code = bin,
    library = lib,
  }
end

M.setup = function(force)
  local install_cmd = [[
    curl -fLO  https://github.com/vadimcn/vscode-lldb/releases/latest/download/codelldb-x86_64-linux.vsix
    unzip codelldb-x86_64-linux.vsix
    rm -vf codelldb-x86_64-linux.vsix
  ]]
  util.terminal.install_package("netcoredbg", basedir, basedir, install_cmd, force)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = bin,
      args = { "--port", "${port}" },
      detached = has("win32") and false or nil,
    },
  }
  dap.configurations.c = {
    {
      name = "Launch via codelldb",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.expand(vim.fn.getcwd() .. "/target/debug/"), "file")
      end,
      cwd = "${workspaceFolder}",
      args = {},
      stopOnEntry = true,
    },
  }
  dap.configurations.cpp = dap.configurations.c
  dap.configurations.rust = dap.configurations.c
end

return M
