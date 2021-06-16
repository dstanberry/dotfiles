---------------------------------------------------------------
-- => Debug Adapter Protocol Configuration
---------------------------------------------------------------
-- verify dap is available
local has_dap, dap = pcall(require, "dap")
if not has_dap then
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
local has_dpy, dpy = pcall(require, "dap-python")
if has_dpy then
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
  dpy.setup("python", { include_configs = true })
end
