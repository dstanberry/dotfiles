-- verify lspconfig is available
local ok, lsp_util = pcall(require, "lspconfig.util")
if not ok then
  return
end

local project_root = function(fname)
  local root_dirs = { ".marksman.toml", ".zk" }
  return lsp_util.find_git_ancestor(fname)
    or lsp_util.root_pattern(unpack(root_dirs))(fname)
    or lsp_util.path.dirname(fname)
end

local M = {}

M.config = {
  cmd = { "marksman" },
  root_dir = project_root,
}

return M
