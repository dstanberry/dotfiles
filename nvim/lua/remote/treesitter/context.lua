local ok, context = pcall(require, "treesitter-context")
if not ok then return end

local groups = require "ui.theme.groups"

groups.new("TreesitterContext", { link = "Normal" })
groups.new("TreesitterContextLineNumber", { link = "LineNr" })
groups.new("TreesitterContextSeparator", { link = "NonText" })

context.setup {
  enable = true,
  multiline_threshold = 4,
  separator = "─",
  mode = "topline",
  patterns = {
    lua = {
      "table",
    },
  },
}
