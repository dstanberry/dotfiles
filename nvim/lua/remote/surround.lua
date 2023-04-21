return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {
    keymaps = {
      insert = "<c-g>s",
      insert_line = "<c-g>S",
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "S",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
    },
    aliases = {
      ["a"] = ">",
      ["p"] = ")",
      ["c"] = "}",
      ["s"] = "]",
      -- change/delete any quote character
      ["q"] = { '"', "'", "`" },
      -- change/delete any of the following delimiters
      ["d"] = { ")", "]", "}", ">", "'", '"', "`" },
    },
    highlight = {
      duration = 0,
    },
  },
}
