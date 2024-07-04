local M = {}

M.setup = function()
  local dap_python = require "dap-python"
  local vscode = require "dap.ext.vscode"

  vscode.type_to_filetypes["python"] = { "python" }

  local cmd = ds.has "win32" and ds.plugin.get_pkg_path("debugpy", "venv/Scripts/pythonw.exe")
    or ds.plugin.get_pkg_path("debugpy", "venv/bin/python")
  dap_python.setup(cmd)
  dap_python.test_runner = "pytest"
end

return M
