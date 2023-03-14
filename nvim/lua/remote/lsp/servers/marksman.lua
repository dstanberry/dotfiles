-- verify lspconfig is available
local ok, lsp_util = pcall(require, "lspconfig.util")
if not ok then return end

local cmd = { "marksman", "server" }
local function get_cmd()
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

local project_root = function(fname)
  local root_dirs = { ".marksman.toml", ".zk" }
  return lsp_util.find_git_ancestor(fname)
    or lsp_util.root_pattern(unpack(root_dirs))(fname)
    or lsp_util.path.dirname(fname)
end

local M = {}

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
  root_dir = project_root,
}

return M
