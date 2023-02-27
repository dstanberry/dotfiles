return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
  keys = {
    { "<localleader>gy", function() require("gitlinker").get_buf_range_url "n" end, desc = "gitlinker: copy line", },
    { "<localleader>gy", function() require("gitlinker").get_buf_range_url "v" end, mode = "v", desc = "neogit: copy range", },
  },
  opts = {
    mappings = nil,
  },
}
