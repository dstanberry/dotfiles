local util = require "util"

local M = {}

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "zk")

local zk_executable = ("%s/zk"):format(basedir)
local zk_notebook = vim.env.hash_notes and ("%s/zettelkasten"):format(vim.env.hash_notes)
  or ("%s/Documents/_notes/zettelkasten"):format(vim.env.HOME)
local zk_template = vim.env.hash_notes and ("%s/../zk/templates"):format(vim.fn.stdpath "config")
  or ("%s/Documents/_notes/zettelkasten/templates"):format(vim.env.HOME)

M.config = {
  cmd = { zk_executable, "lsp" },
}

M.get_executable_path = function()
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    return nil
  end
  return zk_executable
end

M.get_notebook_path = function()
  return zk_notebook
end

M.get_templates_path = function()
  return zk_template
end

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

return M
