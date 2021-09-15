-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "LspDiagnosticsSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "LspDiagnosticsDefaultWarning",
  linehl = "LspDiagnosticsDefaultWarning",
  numhl = "",
})

-- enable virtual text if available
if pcall(require, "nvim-dap-virtual-text") then
  vim.g.dap_virtual_text = true
end

-- debugger setup
dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/kitty",
  args = { "-e" },
}

-- lua (neovim builtin)
dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host, port = config.port }
end
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = "127.0.0.1",
    port = 54321,
  },
}

-- golang
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

-- python
local has_py, dap_python = pcall(require, "dap-python")
if has_py then
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Debug Current File",
      program = "${file}",
      args = { "--target", "api" },
      console = "integratedTerminal",
    },
  }
  dap_python.setup("python", { include_configs = true })
  dap_python.test_runner = "pytest"
end
