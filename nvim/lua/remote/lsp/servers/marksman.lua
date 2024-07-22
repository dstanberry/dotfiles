local M = {}

M.config = {
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(".marksman.toml", ".zk")(fname)
      or require("lspconfig.util").find_git_ancestor(fname)
      or vim.uv.cwd()
  end,
}

return M
