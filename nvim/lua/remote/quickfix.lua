local groups = require "ui.theme.groups"

groups.new("qfPosition", { link = "@text.reference" })

groups.new("BqfPreviewFloat", { link = "NormalFloat" })
groups.new("BqfPreviewBorder", { link = "FloatBorder" })

return {
  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = true,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = true,
  },
}
