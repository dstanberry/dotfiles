local util = require "util"

local M = {}

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "zk")

local zk_executable = vim.env.hash_notes and ("%s/zk"):format(basedir) or ("%s/go/bin/zk.exe"):format(vim.env.HOME)

local win_documents_path = ("%s/Documents"):format(vim.env.HOME)
if has "win32" and vim.fn.empty(vim.fn.glob(win_documents_path)) > 0 then
  if vim.fn.empty(vim.fn.glob "D:\\Documents") == 0 then
    win_documents_path = "D:\\Documents"
  end
end

local zk_notebook = vim.env.hash_notes and ("%s/zettelkasten/vault"):format(vim.env.hash_notes)
  or ("%s/_notes/zettelkasten/vault"):format(win_documents_path)

local zk_template = vim.env.hash_notes and ("%s/../zk/templates"):format(vim.fn.stdpath "config")
  or ("%s/.zk/templates"):format(zk_notebook)

zk_executable = vim.fn.expand(zk_executable)
zk_notebook = vim.fn.expand(zk_notebook)
zk_template = vim.fn.expand(zk_template)

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
