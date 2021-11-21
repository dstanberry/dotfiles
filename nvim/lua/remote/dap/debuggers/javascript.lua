local dap = require "remote.dap"

local path = vim.fn.expand(string.format("%s/dap", vim.fn.stdpath "data"))
local basedir = vim.fn.expand(("%s/%s"):format(path, "vscode-node-debug2"))

local install = function(force)
  if force then
    vim.fn.delete(basedir, "rf")
  end
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    print "Installing vscode-node-debug2..."
    vim.fn.mkdir(basedir, "p")
    local install_cmd = [[
      git clone https://github.com/microsoft/vscode-node-debug2.git
      cd vscode-node-debug2
      npm install
      npm run build
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
    dap.spawn_term(install_cmd, {
      ["cwd"] = path,
      ["on_exit"] = function(_, code)
        if code ~= 0 then
          error "Failed to install vscode-node-debug2"
        end
        print "Installed vscode-node-debug2"
      end,
    })
  end
end


local M = {}

M.setup = function()
  install()
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { ("%s/%s"):format(basedir, "out/src/nodeDebug.js") },
  }
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  }
end

return M
