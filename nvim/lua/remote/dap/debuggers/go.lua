local dap = require "remote.dap"

local M = {}

M.setup = function()
  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", string.format("%s:%s", config.host, config.port) },
      detached = true,
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
    vim.defer_fn(function()
      callback { type = "server", host = config.host, port = config.port }
    end, 100)
  end
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
      host = "127.0.0.1",
      port = 38697,
    },
    {
      type = "go",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "${file}",
      host = "127.0.0.1",
      port = 38697,
    },
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
      host = "127.0.0.1",
      port = 38697,
    },
  }
end

return M
