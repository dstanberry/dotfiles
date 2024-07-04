local M = {}

M.config = {
  root_dir = function(fname)
    local ok, lsp_util = pcall(require, "lspconfig.util")
    local root_dirs = { ".marksman.toml", ".zk" }
    return ok
        and (lsp_util.find_git_ancestor(fname) or lsp_util.root_pattern(unpack(root_dirs))(fname) or lsp_util.path.dirname(
          fname
        ))
      or ds.buffer.get_root()
  end,
}

return M
