return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "flash: search" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "flash: search w/ treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "flash: replace" },
      { "R", mode = { "n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "flash: replace w/ treesitter" },
    },
    opts = {
      modes = {
        char = {
          enabled = true,
          -- keys = { "f", "F", "t", "T", ";", "," },
          keys = { "f", "F", "t", "T", "," },
        },
      },
    },
  },
}
