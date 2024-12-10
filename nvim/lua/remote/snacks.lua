return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local git_opts = {}
      if ds.has "wsl" then git_opts.open = function(url) vim.system { "cmd.exe", "/c", "start", url } end end
      if vim.g.ds_env.github_hostname then
        git_opts.url_patterns = {
          [vim.g.ds_env.github_hostname] = { branch = "/tree/{branch}", file = "/blob/{branch}/{file}#L{line}" },
        }
      end
      local git_y_opts = vim.deepcopy(git_opts)
      git_y_opts.open = function(url) vim.fn.setreg("+", url) end
      local lazygit_opts = {
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
        { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "lsp: goto next reference" },
        { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "lsp: goto prev reference" },
        {"<leader>gg", function() require("snacks").lazygit.open(lazygit_opts) end, desc = "git: lazygit",},
        {"<leader>gl", function() require("snacks").lazygit.log_file(lazygit_opts) end, desc = "git: lazygit log",},
        {"<localleader>go", function() require("snacks").gitbrowse.open(git_opts) end, desc = "git: open in browser", mode = { "n", "v" },},
        {"<localleader>gy", function() require("snacks").gitbrowse.open(git_y_opts) end, desc = "git: copy remote url", mode = { "n", "v" },},
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
      styles = {
        notification = { wo = { wrap = true } },
        scratch = { wo = { winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorderSB" } },
      },
      bigfile = { enabled = true },
      gitbrowse = { enabled = true },
      quickfile = { enabled = true },
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
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      indent = {
        indent = { blank = "·", char = ds.icons.misc.VerticalBar, hl = "NonText" },
        scope = {
          char = ds.icons.misc.VerticalBar,
          underline = true,
          hl = vim.tbl_map(function(i) return "SnacksIndent" .. i end, vim.fn.range(1, 8)),
        },
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
      notifier = {
        timeout = 3000,
        style = "compact",
        icons = {
          error = ds.icons.diagnostics.Error,
          warn = ds.icons.diagnostics.Warn,
          info = "",
          debug = ds.icons.debug.Watches,
          trace = ds.icons.debug.Continue,
        },
      },
    },
  },
}
