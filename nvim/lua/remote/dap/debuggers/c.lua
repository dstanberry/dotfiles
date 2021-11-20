local dap = require "remote.dap"

local path = string.format("%s/dap", vim.fn.stdpath "data")
local basedir = vim.fn.expand(("%s/%s"):format(path, "codelldb"))

local bootstrap = function()
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    vim.fn.mkdir(basedir, "p")
    print "Installing codelldb..."
    local out = vim.fn.system(string.format(
      [[cd %s
      curl -fLO  https://github.com/vadimcn/vscode-lldb/releases/latest/download/codelldb-x86_64-linux.vsix
      unzip codelldb-x86_64-linux.vsix
      rm -vf codelldb-x86_64-linux.vsix]],
      basedir
    ))
    print(out)
  end
end

local M = {}

M.setup = function()
  bootstrap()
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
M.setup()
return M
