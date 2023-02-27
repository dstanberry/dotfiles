local groups = require "ui.theme.groups"

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
  config = function(_, opts)
    local glance = require "glance"
    opts.mappings = {
      list = {
        ["<c-f>"] = glance.actions.preview_scroll_win(5),
        ["<c-d>"] = glance.actions.preview_scroll_win(-5),
      },
      preview = {
        ["q"] = glance.actions.close,
      },
    }
    glance.setup(opts)
    groups.new("GlancePreviewMatch", { link = "Visual" })
  end,
}
