local util = require "remote.snacks.util"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local browse = util.gitbrowse.browse
      local copy = util.gitbrowse.copy_url
      -- stylua: ignore
      return {
        -- lsp
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "lsp: goto next reference" },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "lsp: goto prev reference" },
        -- git
        { "<leader>gg", function() Snacks.lazygit.open() end, desc = "git: lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "git: lazygit log" },
        { "<localleader>go", function() Snacks.gitbrowse.open(browse) end, desc = "git: open in browser", mode = { "n", "v" } },
        { "<localleader>gy", function() Snacks.gitbrowse.open(copy) end, desc = "git: copy remote url", mode = { "n", "v" } },
        -- window
        { "<leader>wn", function() Snacks.notifier.show_history() end, desc = "messages: show notifications" },
        { "<leader>ws", function() util.scratch.select() end, desc = "snacks: select scratchpad" },
        { "<leader>wt", function() Snacks.terminal.toggle() end, desc = "snacks: toggle terminal" },
        { "<leader>wz", function() Snacks.zen.zen() end, desc = "snacks: zen mode" },
      }
    end,
    init = function() util.on_init() end,
    opts = {
      -- buffer/window options
      styles = util.styles,
      -- plugins using default config
      bigfile = { enabled = true },
      gitbrowse = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      -- plugins with custom config
      dashboard = util.dashboard.config,
      indent = util.indent.config,
      input = { win = { keys = { i_jk = { "jk", { "cmp_close", "cancel" }, mode = "i" } } } },
      lazygit = util.lazygit.config,
      notifier = { style = "compact" },
    },
  },
}
