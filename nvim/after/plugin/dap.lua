---------------------------------------------------------------
-- => Debug Adapter Protocol Configuration
---------------------------------------------------------------
-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local map = require "util.map"

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
local has_py, py = pcall(require, "dap-python")
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
  py.setup("python", { include_configs = true })
end

-- define keymaps
map.nnoremap("<localleader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>")
map.nnoremap("<localleader>dr", "<cmd>lua require('dap').repl_open()<cr>")
map.nnoremap("<localleader>dh", "<cmd>lua require('dap.ui.variables').hover()<cr>")
map.nnoremap("<f5>", "<cmd>lua require('dap').continue()<cr>")
map.nnoremap("<f10>", "<cmd>lua require('dap').step_over()<cr>")
