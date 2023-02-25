return {
  "uga-rosa/ccc.nvim",
  event = "VeryLazy",
  cmd = { "CccHighlighterToggle" },
  ft = {
    "javascript",
    "javascriptreact",
    "lua",
    "typescript",
    "typescriptreact",
  },
  opts = {
    highlighter = {
      auto_enable = true,
      excludes = {},
    },
  },
}
