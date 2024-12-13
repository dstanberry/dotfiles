return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local ghe = vim.g.ds_env.github_hostname
      local browse = {
        open = ds.has "wsl" and function(url) vim.system { "cmd.exe", "/c", "start", url } end,
        url_patterns = ghe and { [ghe] = { branch = "/tree/{branch}", file = "/blob/{branch}/{file}#L{line}" } },
      }
      local opts2 = { url_pattern = browse.url_patterns, open = function(url) vim.fn.setreg("+", url) end }
      local lazygit = {
        theme = {
          [241] = { fg = "Special" },
          defaultFgColor = { fg = "Normal" },
          activeBorderColor = { fg = "Function", bold = true },
          inactiveBorderColor = { fg = "Comment" },
          optionsTextColor = { fg = "Function" },
          selectedLineBgColor = { bg = "Visual" },
          unstagedChangesColor = { fg = "DiagnosticError" },
          cherryPickedCommitBgColor = { bg = "default" },
          cherryPickedCommitFgColor = { fg = "Identifier" },
          searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        },
      }
      -- stylua: ignore
      return {
        -- lsp
        { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "lsp: goto next reference" },
        { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "lsp: goto prev reference" },
        -- git
        {"<leader>gg", function() require("snacks").lazygit.open(lazygit) end, desc = "git: lazygit",},
        {"<leader>gl", function() require("snacks").lazygit.log_file(lazygit) end, desc = "git: lazygit log",},
        {"<localleader>go", function() require("snacks").gitbrowse.open(browse) end, desc = "git: open in browser", mode = { "n", "v" },},
        {"<localleader>gy", function() require("snacks").gitbrowse.open(opts2) end, desc = "git: copy remote url", mode = { "n", "v" },},
        -- windows
        { "<leader>wn", function() Snacks.notifier.show_history() end, desc = "messages: show notifications" },
        { "<leader>ws", function() Snacks.scratch.select() end, desc = "scratchpad: select note" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.print = function(...) Snacks.debug.inspect(...) end

          ds.info = function(msg, opts)
            opts = opts or {}
            opts.title = opts.title or "Info"
            Snacks.notify.info(msg, opts)
          end
          ds.warn = function(msg, opts)
            opts = opts or {}
            opts.title = opts.title or "Warning"
            Snacks.notify.warn(msg, opts)
          end
          ds.error = function(msg, opts)
            opts = opts or {}
            opts.title = opts.title or "Error"
            Snacks.notify.error(msg, opts)
          end
        end,
      })
    end,
    opts = {
      -- stylua: ignore
      styles = {
        notification = { wo = { wrap = true } },
        -- HACK: unable to unlink `SnacksNotifierHistoryTitle`
        ["notification.history"] = { wo = { cursorline = false, winhighlight = "FloatBorder:FloatBorderSB,Title:SnacksNotifierHistoryTitle" } },
        scratch = { wo = { winhighlight = "FloatBorder:FloatBorderSB,CursorLine:SnacksScratchCursorLine" } },
      },
      bigfile = { enabled = true },
      gitbrowse = { enabled = true },
      notifier = { style = "compact" },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      dashboard = {
        preset = {
          -- stylua: ignore
          keys = {
            { key = "f", action = require("remote.telescope.util").files.project, icon = ds.pad(ds.icons.misc.Magnify, "right"), desc = " Find File" },
            { key = "n", action = ":ene | startinsert", icon = ds.pad(ds.icons.documents.File, "right"), desc = " New File" },
            { key = "g", action = require("remote.telescope.util").grep.dynamic, icon = ds.pad(ds.icons.misc.Data, "right"), desc = " Find Text" },
            { key = "r", action = function() require("persistence").load() end, icon = ds.pad(ds.icons.misc.Revolve, "right"), desc = " Restore Session" },
            { key = "c", action = require("remote.telescope.util").files.nvim_config, icon = ds.pad(ds.icons.misc.Gear, "right"), desc = " Configuration File" },
            { key = "l", action = ":Lazy", icon = ds.pad(ds.icons.misc.Sleep, "right"), desc = " Plugin Manager" },
            { key = "q", action = function() vim.api.nvim_input "<cmd>qa<cr>" end, icon = ds.pad(ds.icons.misc.Exit, "right"), desc = " Quit" },
          },
        },
        sections = { { section = "header" }, { section = "keys", gap = 1, padding = 1 }, { section = "startup" } },
      },
      indent = {
        indent = { blank = "·", char = ds.icons.misc.VerticalBarThin, hl = "NonText" },
        -- stylua: ignore
        scope = { char = ds.icons.misc.VerticalBar, underline = true, hl = vim.tbl_map(function(i) return "SnacksIndent" .. i end, vim.fn.range(1, 8)) },
        filter = function(buf)
          local filetypes = vim.tbl_deep_extend(
            "keep",
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
