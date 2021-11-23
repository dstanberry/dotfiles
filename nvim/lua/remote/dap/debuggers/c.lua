local dap = require "remote.dap"
local util = require "util"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = vim.fn.expand(("%s/%s"):format(path, "codelldb"))

local install = function(force)
  if force then
    vim.fn.delete(basedir, "rf")
  end
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    print "Installing codelldb..."
    vim.fn.mkdir(basedir, "p")
    local install_cmd = [[
      curl -fLO  https://github.com/vadimcn/vscode-lldb/releases/latest/download/codelldb-x86_64-linux.vsix
      unzip codelldb-x86_64-linux.vsix
      rm -vf codelldb-x86_64-linux.vsix
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
      ["cwd"] = basedir,
      ["on_exit"] = function(_, code)
        if code ~= 0 then
          error "Failed to install codelldb"
        end
        print "Installed codelldb"
      end,
    })
  end
end

local M = {}

M.setup = function(force)
  install(force)
  dap.adapters.codelldb = function(on_adapter)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local cmd = vim.fn.expand(("%s/%s"):format(basedir, "extension/adapter/codelldb"))
    local handle, pid_or_err
    local opts = {
      stdio = { nil, stdout, stderr },
      detached = true,
    }
    handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
      stdout:close()
      stderr:close()
      handle:close()
      if code ~= 0 then
        print("codelldb exited with code", code)
      end
    end)
    assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        local port = chunk:match "Listening on port (%d+)"
        if port then
          vim.schedule(function()
            on_adapter {
              type = "server",
              host = "127.0.0.1",
              port = port,
            }
          end)
        else
          vim.schedule(function()
            require("dap.repl").append(chunk)
          end)
        end
      end
    end)
    stderr:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
  end
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
    },
  }
  dap.configurations.cpp = dap.configurations.c
  dap.configurations.rust = dap.configurations.c
end

return M
