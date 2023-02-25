return {
  "akinsho/git-conflict.nvim",
  event = "VeryLazy",
  opts = {
    default_mappings = true,
    disable_diagnostics = false,
    highlights = {
      incoming = "DiffText",
      current = "DiffAdd",
    },
  },
}
