return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end, desc = "persistence: save session" },
      { "<leader>qr", function() require("persistence").load() end, desc = "persistence: restore session" },
      { "<leader>ql", function() require("persistence").load { last = true } end, desc = "persistence: restore last session" },
      { "<localleader>qs", function() require("persistence").stop() end, desc = "persistence: untrack session" },
    },
  },
}
