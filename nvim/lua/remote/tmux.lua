return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    { "<a-h>", function() require("smart-splits").resize_left(1) end, desc = "smart-splits: resize left" },
    { "<a-j>", function() require("smart-splits").resize_down(1) end, desc = "smart-splits: resize down" },
    { "<a-k>", function() require("smart-splits").resize_up(1) end, desc = "smart-splits: resize up" },
    { "<a-l>", function() require("smart-splits").resize_right(1) end, desc = "smart-splits: resize right" },
    -- moving between splits
    { "<c-h>", function() require("smart-splits").move_cursor_left() end, desc = "smart-splits: move to left window" },
    {
      "<c-j>",
      function() require("smart-splits").move_cursor_down() end,
      desc = "smart-splits: move to lower window",
    },
    { "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "smart-splits: move to upper window" },
    {
      "<c-l>",
      function() require("smart-splits").move_cursor_right() end,
      desc = "smart-splits: move to right window",
    },
    -- swapping buffers between windows
    {
      "<localleader><localleader>h",
      function() require("smart-splits").swap_buf_left() end,
      desc = "smart-splits: swap with left window",
    },
    {
      "<localleader><localleader>j",
      function() require("smart-splits").swap_buf_down() end,
      desc = "smart-splits: swap with lower window",
    },
    {
      "<localleader><localleader>k",
      function() require("smart-splits").swap_buf_up() end,
      desc = "smart-splits: swap with upper window",
    },
    {
      "<localleader><localleader>l",
      function() require("smart-splits").swap_buf_right() end,
      desc = "smart-splits: swap with right window",
    },
  },
  config = true,
}
