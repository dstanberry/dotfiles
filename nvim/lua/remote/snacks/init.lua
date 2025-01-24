return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local gitbrowse_config = require "remote.snacks.gitbrowse"
      local browse = gitbrowse_config.browse
      local copy = gitbrowse_config.copy_url
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
        { "<leader>ws", function() require("remote.snacks.scratch").select() end, desc = "snacks: select scratchpad" },
        { "<leader>wt", function() Snacks.terminal.toggle() end, desc = "snacks: toggle terminal" },
        { "<leader>wz", function() Snacks.zen.zen() end, desc = "snacks: zen mode" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd(
        "User",
        { pattern = "VeryLazy", callback = require("remote.snacks.notify").init_notify }
      )
    end,
    opts = {
      styles = {
        input = { row = 19 },
        notification = { wo = { wrap = true } },
        notification_history = {
          wo = { cursorline = false, winhighlight = "FloatBorder:FloatBorderSB,Title:SnacksNotifierHistoryTitle" },
        },
        scratch = { wo = { winhighlight = "FloatBorder:FloatBorderSB,CursorLine:SnacksScratchCursorLine" } },
        terminal = { wo = { winbar = "" } },
      },
      bigfile = { enabled = true },
      gitbrowse = { enabled = true },
      input = { win = { keys = { i_jk = { "jk", { "cmp_close", "cancel" }, mode = "i" } } } },
      notifier = { style = "compact" },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      dashboard = {
        preset = require("remote.snacks.dashboard").default_preset,
        sections = { { section = "header" }, { section = "keys", gap = 1, padding = 1 }, { section = "startup" } },
      },
      lazygit = {
        theme = require("remote.snacks.lazygit").theme,
        win = {
          keys = {
            cj = { "<c-j>", "ctrl_j", expr = true, mode = "t" },
            ck = { "<c-k>", "ctrl_k", expr = true, mode = "t" },
          },
          actions = { ctrl_j = function() return "<c-j>" end, ctrl_k = function() return "<c-k>" end },
        },
      },
      indent = {
        indent = { blank = "·", char = ds.icons.misc.VerticalBarThin, hl = "NonText" },
        scope = {
          char = ds.icons.misc.VerticalBar,
          underline = true,
          hl = vim.tbl_map(function(i) return "SnacksIndent" .. i end, vim.fn.range(1, 8)),
        },
        filter = function(buf)
          local filetypes = ds.extend(
            ds.excludes.ft.stl_disabled,
            ds.excludes.ft.wb_disabled,
            ds.excludes.ft.wb_empty,
            { "checkhealth", "diff", "git" },
            { "log", "markdown", "txt" }
          )
          if vim.tbl_contains(filetypes, vim.bo[buf].filetype) then vim.b[buf].snacks_indent = false end
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
    },
  },
}
