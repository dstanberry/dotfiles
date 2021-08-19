---------------------------------------------------------------
-- => Debug Adapter Protocol Configuration
---------------------------------------------------------------
-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

-- enable virtual text if available
if pcall(require, "nvim-dap-virtual-text") then
  vim.g.dap_virtual_text = true
end

-- debugger setup
dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/kitty",
  args = { "-e" },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = "127.0.0.1",
    port = 54321,
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host, port = config.port }
end

-- setup dap-python if available
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

require "remote.dap.ui"
require "remote.dap.keymap"
