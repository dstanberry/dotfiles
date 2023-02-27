return {
  "DNLHC/glance.nvim",
  -- stylua: ignore
  keys = {
    { "gD", function() vim.cmd { cmd = "Glance", args = { "definitions" } } end, desc = "glance: lsp definitions" },
    { "gI", function() vim.cmd { cmd = "Glance", args = { "implementations" } } end, desc = "glance: lsp implementations" },
    { "gR", function() vim.cmd { cmd = "Glance", args = { "references" } } end, desc = "glance: lsp references" },
    { "gT", function() vim.cmd { cmd = "Glance", args = { "type_definitions" } } end, desc = "glance: lsp type definitions" },
  },
  opts = {
    preview_win_opts = {
      relativenumber = false,
    },
    theme = {
      enable = true,
      mode = "darken",
    },
  },
}
