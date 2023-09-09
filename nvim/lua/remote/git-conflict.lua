return {
  "akinsho/git-conflict.nvim",
  lazy = true,
  version = "*",
  opts = {
    default_mappings = true,
    disable_diagnostics = false,
    highlights = {
      incoming = "DiffText",
      current = "DiffAdd",
    },
  },
}
