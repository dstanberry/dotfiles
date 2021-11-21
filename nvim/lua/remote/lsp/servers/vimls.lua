-- verify lspconfig is available
local ok, util = pcall(require, "lspconfig.util")
if not ok then
  return
end

local project_root = function(fname)
  local root_dirs = { "nvim", "vim" }
  return util.find_git_ancestor(fname) or util.root_pattern(unpack(root_dirs))(fname) or util.path.dirname(fname)
end

local M = {}

M.config = {
  vimruntime = vim.fn.expand "$VIMRUNTIME",
  root_dir = project_root,
}

return M
