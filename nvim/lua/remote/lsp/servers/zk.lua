local util = require "util"

local M = {}

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "zk")
local executable = ("%s/zk"):format(basedir)

local zk_notebook = vim.env.hash_notes and ("%s/zettelkasten"):format(vim.env.hash_notes)
  or ("%s/Documents/_notes"):format(vim.env.HOME)

M.setup = function(force)
  local install_cmd = string.format(
    [[
    git clone https://github.com/mickael-menu/zk.git
    cd zk
    make
    mkdir -vp %s/vault/{inbox,journal,literature,permanent}
  ]],
    zk_notebook
  )
  util.terminal.install_package("zk", basedir, path, install_cmd, force)
end

M.config = {
  cmd = { executable, "lsp" },
}

M.get_executable_path = function()
  return executable
end

M.get_notebook_path = function()
  return zk_notebook
end

return M
