return {
  "DNLHC/glance.nvim",
  -- stylua: ignore
  keys = {
    { "gD", function() vim.cmd { cmd = "Glance", args = { "definitions" } } end, },
    { "gI", function() vim.cmd { cmd = "Glance", args = { "implementations" } } end, },
    { "gR", function() vim.cmd { cmd = "Glance", args = { "references" } } end, },
    { "gT", function() vim.cmd { cmd = "Glance", args = { "type_definitions" } } end, },
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
