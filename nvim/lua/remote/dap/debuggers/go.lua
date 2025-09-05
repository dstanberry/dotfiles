local M = {}

M.setup = function()
  local dap = require "dap"
  local vscode = require "dap.ext.vscode"

  vscode.type_to_filetypes["delve"] = { "go" }

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = ds.plugin.get_pkg_path("dlv", { exe = true }),
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }
  dap.configurations.go = {
    {
      type = "delve",
      name = "Launch new process",
      request = "launch",
      program = "${file}",
      console = "integratedTerminal",
    },
    {
      type = "delve",
      name = "Launch new process [test(s)]",
      request = "launch",
      mode = "test",
      program = "${file}",
      console = "integratedTerminal",
    },
    {
      type = "delve",
      name = "Launch new process [test go.mod]",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
      console = "integratedTerminal",
    },
  }
end

return M
