local ft = {
  "css",
  "html",
  "javascript",
  "javascriptreact",
  "lua",
  "typescript",
  "typescriptreact",
}

return {
  "uga-rosa/ccc.nvim",
  event = "VeryLazy",
  cmd = { "CccHighlighterToggle" },
  ft = ft,
  opts = {
    highlighter = {
      auto_enable = true,
      filetypes = ft,
    },
  },
}
