-- verify lspconfig is available
local ok, lsp_util = pcall(require, "lspconfig.util")
if not ok then
  return
end

local util = require "util"

local project_root = function(fname)
  local root_dirs = { ".marksman.toml", ".zk" }
  return lsp_util.find_git_ancestor(fname)
    or lsp_util.root_pattern(unpack(root_dirs))(fname)
    or lsp_util.path.dirname(fname)
end

local fname
local oname
if has "win32" then
  oname = "marksman-win"
  fname = "marksman.exe"
else
  oname = "marksman-linux"
  fname = "marksman"
end

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = string.format("%s/marksman/bin", path)
local executable = string.format("%s/%s", basedir, fname)

local M = {}

M.setup = function(force)
  local install_cmd = ([[
    cd %s/.config/shared/bin
    cp %s %s
  ]]):format(vim.env.HOME, oname, executable)
  util.terminal.install_package("marksman", basedir, path, install_cmd, force)
end

M.config = {
  cmd = { executable },
  root_dir = project_root,
}

return M
