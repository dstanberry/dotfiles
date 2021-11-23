local dap = require "remote.dap"
local util = require "util"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "netcoredbg")

local install = function(force)
  if force then
    vim.fn.delete(basedir, "rf")
  end
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    print "Installing netcoredbg..."
    vim.fn.mkdir(path, "p")
    local install_cmd = [[
      curl -fLO https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz
      tar -xzvf netcoredbg-linux-amd64.tar.gz
      rm -vf netcoredbg-linux-amd64.tar.gz
      ]]
    if vim.fn.has "win32" then
      local win_cmd = ""
      for cmd in install_cmd:gmatch "([^\n]*)\n?" do
        cmd = cmd:gsub("^%s*", "")
        if #cmd > 0 then
          if #win_cmd == 0 then
            win_cmd = cmd
          else
            win_cmd = ("%s && %s"):format(win_cmd, cmd)
          end
        end
      end
      install_cmd = win_cmd
    end
    util.spawn_term(install_cmd, {
      ["cwd"] = path,
      ["on_exit"] = function(_, code)
        if code ~= 0 then
          error "Failed to install netcoredbg"
        end
        print "Installed netcoredbg"
      end,
    })
  end
end

local M = {}

M.setup = function(force)
  install(force)
  dap.adapters.netcoredbg = {
    type = "executable",
    args = { "--interpreter=vscode" },
    command = vim.fn.expand(("%s/%s"):format(basedir, "netcoredbg")),
  }
  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to dll", vim.fn.expand(vim.fn.getcwd() .. "/bin/Debug/"), "file")
      end,
      stopAtEntry = true,
    },
  }
end

return M
