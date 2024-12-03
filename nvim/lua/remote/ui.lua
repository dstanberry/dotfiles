return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = function()
      local _toggle = function()
        local action = require("diffview.lib").get_current_view() and "Close" or "Open"
        vim.cmd("Diffview" .. action)
      end

      return {
        { "<localleader>gd", _toggle, desc = "diffview: toggle diff" },
        { "<localleader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview: file history" },
        { "<localleader>gh", ":'<'>DiffviewFileHistory<cr>", desc = "diffview: file history", mode = "v" },
      }
    end,
    config = function()
      local diffview = require "diffview"
      local lazy = require "diffview.lazy"
      local lib = lazy.require "diffview.lib"
      local Diff2Hor = lazy.access("diffview.scene.layouts.diff_2_hor", "Diff2Hor")
      local Diff2Ver = lazy.access("diffview.scene.layouts.diff_2_ver", "Diff2Ver")
      local Diff3 = lazy.access("diffview.scene.layouts.diff_3", "Diff3")
      local Diff4 = lazy.access("diffview.scene.layouts.diff_4", "Diff4")

      diffview.setup {
        diff_binaries = false,
        use_icons = true,
        enhanced_diff_hl = true,
        icons = {
          folder_closed = ds.pad(ds.icons.documents.FolderOutlineClosed, "right"),
          folder_open = ds.pad(ds.icons.documents.FolderOutlineClosed, "right"),
        },
        signs = {
          fold_closed = ds.icons.misc.FoldClosed,
          fold_open = ds.icons.misc.FoldOpened,
        },
        view = {
          default = { layout = "diff2_horizontal" },
          file_history = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_mixed" },
        },
        file_panel = {
          listing_style = "list",
          win_config = {
            position = "left",
            width = 35,
            height = 10,
            win_opts = { winhighlight = "Normal:NormalSB" },
          },
        },
        file_history_panel = {
          win_config = {
            position = "bottom",
            width = 35,
            height = 20,
            win_opts = { winhighlight = "Normal:NormalSB" },
          },
        },
        hooks = {
          diff_buf_read = function(bufnr, _)
            vim.opt_local.colorcolumn = ""
            vim.opt_local.relativenumber = false

            local view = lib.get_current_view()
            local file = view.cur_entry
            local target = ""
            if file then
              local layout = file.layout
              if layout:instanceof(Diff2Hor.__get()) or layout:instanceof(Diff2Ver.__get()) then
                if bufnr == layout.a.file.bufnr then
                  target = "Previous"
                elseif bufnr == layout.b.file.bufnr then
                  target = "Current"
                end
              elseif layout:instanceof(Diff3.__get()) then
                vim.api.nvim_buf_set_var(bufnr, "diffview_view", "merge")
                if bufnr == layout.a.file.bufnr then
                  target = "Current"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.a.file.winbar)
                elseif bufnr == layout.b.file.bufnr then
                  target = "Result"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.b.file.winbar)
                elseif bufnr == layout.c.file.bufnr then
                  target = "Incoming"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.c.file.winbar)
                end
              elseif layout:instanceof(Diff4.__get()) then
                vim.api.nvim_buf_set_var(bufnr, "diffview_view", "merge")
                if bufnr == layout.a.file.bufnr then
                  target = "Current"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.a.file.winbar)
                elseif bufnr == layout.b.file.bufnr then
                  target = "Result"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.b.file.winbar)
                elseif bufnr == layout.c.file.bufnr then
                  target = "Incoming"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.c.file.winbar)
                elseif bufnr == layout.d.file.bufnr then
                  target = "Common Ancestor"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.d.file.winbar)
                end
              end
              vim.api.nvim_buf_set_var(bufnr, "bufid", "diffview")
              vim.api.nvim_buf_set_var(bufnr, "diffview_label", target)
            end
          end,
        },
        keymaps = {
          view = { q = diffview.close },
          file_panel = { q = diffview.close },
          file_history_panel = { q = diffview.close },
          option_panel = { q = diffview.close },
        },
      }
      diffview.init()
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
    end,
    opts = function()
      local function get_height(self, _, max_lines)
        local results = #self.finder.results
        local PADDING = 4
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
      end

      return {
        input = {
          enabled = false,
          insert_only = false,
          title_pos = "left",
          border = "single",
          relative = "editor",
          prefer_width = 60,
          win_options = {
            winblend = vim.o.pumblend,
            winhighlight = "NormalFloat:Normal,FloatBorder:DiagnosticInfo",
          },
        },
        select = {
          backend = "telescope",
          telescope = require("telescope.themes").get_dropdown {
            layout_config = { height = get_height, prompt_position = "top" },
            previewer = false,
          },
        },
      }
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = { hl_group = "Substitute" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      indent = { char = ds.icons.misc.VerticalBarThin },
      scope = { enabled = false },
      exclude = {
        filetypes = vim.tbl_deep_extend(
          "keep",
          ds.excludes.ft.stl_disabled,
          ds.excludes.ft.wb_disabled,
          ds.excludes.ft.wb_empty,
          { "checkhealth", "diff", "git" },
          { "log", "markdown", "txt" }
        ),
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
    end,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        -- stylua: ignore
        format = {
          search_down = {  lang = "regex", view = "cmdline" },
          search_up = {  lang = "regex", view = "cmdline" },
          substitute = { kind = "search", pattern = "^:'?<?,?'?>?%%?s/", icon = ds.icons.misc.ArrowSwap, lang = "regex", view = "cmdline" },
        },
      },
      lsp = {
        documentation = {
          opts = {
            border = { style = ds.icons.border.Default },
            position = { row = 2 },
            win_options = { winhighlight = { FloatBorder = "FloatBorderSB" } },
          },
        },
        signature = {
          opts = { position = { row = 2 } },
        },
        override = {
          ["cmp.entry.get_documentation"] = true,
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        {
          opts = { skip = true },
          event = "msg_show",
          filter = {
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { kind = "search_count" },
            },
          },
        },
        {
          filter = { event = "msg_show", min_height = 10 },
          view = "cmdline_output",
        },
      },
      views = {
        cmdline_popup = {
          border = { style = "single" },
          position = { col = "50%", row = 20 },
          size = { height = "auto", min_width = 70 },
        },
        mini = {
          position = { row = -2 },
          win_options = { winblend = vim.o.pumblend },
        },
        popupmenu = {
          border = { style = "single" },
          position = { row = 23, col = "50%" },
          size = { width = 70, height = 10 },
          win_options = { winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" } },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local git_opts = {}
      if ds.has "wsl" then git_opts.open = function(url) vim.system { "cmd.exe", "/c", "start", url } end end
      if vim.g.ds_env.github_hostname then
        git_opts.url_patterns = {
          [vim.g.ds_env.github_hostname] = {
            branch = "/tree/{branch}",
            file = "/blob/{branch}/{file}#L{line}",
          },
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
      },
      bigfile = { enabled = true },
      gitbrowse = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            {
              key = "f",
              action = require("remote.telescope.util").files.project,
              icon = ds.pad(ds.icons.misc.Magnify, "right"),
              desc = " Find File",
            },
            {
              key = "n",
              action = ":ene | startinsert",
              icon = ds.pad(ds.icons.documents.File, "right"),
              desc = " New File",
            },
            {
              key = "g",
              action = require("remote.telescope.util").grep.dynamic,
              icon = ds.pad(ds.icons.misc.Data, "right"),
              desc = " Find Text",
            },
            {
              key = "r",
              action = function() require("persistence").load() end,
              icon = ds.pad(ds.icons.misc.Revolve, "right"),
              desc = " Restore Session",
            },
            {
              key = "c",
              action = require("remote.telescope.util").files.nvim_config,
              icon = ds.pad(ds.icons.misc.Gear, "right"),
              desc = " Configuration File",
            },
            {
              key = "l",
              action = ":Lazy",
              icon = ds.pad(ds.icons.misc.Sleep, "right"),
              desc = " Plugin Manager",
            },
            {
              key = "q",
              action = function() vim.api.nvim_input "<cmd>qa<cr>" end,
              icon = ds.pad(ds.icons.misc.Exit, "right"),
              desc = " Quit",
            },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        icons = {
          error = ds.icons.diagnostics.Error,
          warn = ds.icons.diagnostics.Warn,
          info = "",
          debug = ds.icons.debug.Watches,
          trace = ds.icons.debug.Continue,
        },
        style = "compact",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoQuickFix", "TodoTelescope", "TodoTrouble" },
    opts = {
      signs = false,
      sign_priority = 0,
      colors = {
        error = { ds.color.blend(vim.g.ds_colors.red1, vim.g.ds_colors.gray1, 0.31) },
        warning = { ds.color.blend(vim.g.ds_colors.rose0, vim.g.ds_colors.gray1, 0.31) },
        info = { ds.color.blend(vim.g.ds_colors.aqua1, vim.g.ds_colors.gray1, 0.31) },
        hint = { ds.color.blend(vim.g.ds_colors.magenta1, vim.g.ds_colors.gray1, 0.31) },
        default = { ds.color.blend(vim.g.ds_colors.blue0, vim.g.ds_colors.gray1, 0.31) },
        test = { ds.color.blend(vim.g.ds_colors.green0, vim.g.ds_colors.gray1, 0.31) },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "ufo: peek content within fold" },
    },
    init = function()
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = "none",
          maxheight = 20,
          winblend = vim.o.pumblend,
          winhighlight = "Normal:NormalSB",
        },
      },
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virt_text, _, end_linenr, width, truncatefn, ctx)
        local result = {}
        local padding = ""
        local cur_width = 0
        local suffix_width = vim.api.nvim_strwidth(ctx.text)
        local target_width = width - suffix_width

        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.api.nvim_strwidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncatefn(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.api.nvim_strwidth(chunk_text)
            if cur_width + chunk_width < target_width then
              padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end
        local end_text = ctx.get_fold_virt_text(end_linenr)
        if end_text[1] and end_text[1][1] then end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "") end
        table.insert(result, { ds.pad(ds.icons.misc.Ellipses, "both"), "Comment" })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, "" })
        return result
      end,
      provider_selector = function() return { "treesitter", "indent" } end,
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "BufReadPre",
    opts = {
      char = ds.icons.misc.VerticalBarVeryThin,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        preset = "helix",
        win = {
          border = ds.map(ds.icons.border.Default, function(icon) return { icon, "WhichKeyBorder" } end),
          title = false,
        },
        keys = { scroll_down = "<c-d>", scroll_up = "<c-f>" },
        icons = {
          rules = {
            -- groups
            { pattern = "command", icon = " ", color = "azure" },
            { pattern = "copilot", icon = " ", color = "grey" },
            { pattern = "dap", icon = " ", color = "red" },
            { pattern = "debug", icon = " ", color = "red" },
            { pattern = "database", icon = " ", color = "yellow" },
            { pattern = "lsp", icon = " ", color = "red" },
            { pattern = "notes", icon = " ", color = "purple" },
            { pattern = "quickfix", icon = " ", color = "grey" },
            { pattern = "substitute", icon = " ", color = "green" },
            { pattern = "test", icon = " ", color = "yellow" },
            { pattern = "trouble", icon = " ", color = "yellow" },
            -- primary actions
            { pattern = "diff", icon = "", color = "azure" },
            { pattern = "fold", icon = " ", color = "azure" },
            { pattern = "grep", icon = " ", color = "orange" },
            { pattern = "mark", icon = " ", color = "yellow" },
            { pattern = "regex", icon = " ", color = "yellow" },
            { pattern = "workspace", icon = " ", color = "yellow" },
            -- overrides
            { pattern = "harpoon", icon = "󰛢 ", color = "cyan" },
            { plugin = "grug-far", icon = " ", color = "blue" },
            { pattern = "find", icon = " ", color = "green" },
            { pattern = "search", icon = " ", color = "green" },
            { pattern = "buffer", icon = " ", color = "purple" },
            -- secondary actions
            { pattern = "create", icon = " ", color = "green" },
            { pattern = "insert", icon = " ", color = "cyan" },
            { pattern = "new", icon = " ", color = "green" },
            { pattern = "launch", icon = " ", color = "green" },
            { pattern = "run", icon = " ", color = "green" },
            { pattern = "close", icon = " ", color = "red" },
            { pattern = "stop", icon = " ", color = "red" },
            { pattern = "reload", icon = " ", color = "green" },
            { pattern = "reset", icon = " ", color = "green" },
            { pattern = "restore", icon = " ", color = "grey" },
            { pattern = "delete", icon = " ", color = "red" },
            { pattern = "open", icon = " ", color = "green" },
            { pattern = "bottom", icon = " ", color = "grey" },
            { pattern = "down", icon = " ", color = "grey" },
            { pattern = "left", icon = " ", color = "grey" },
            { pattern = "right", icon = " ", color = "grey" },
            { pattern = "top", icon = " ", color = "grey" },
            { pattern = "up", icon = " ", color = "grey" },
            { pattern = "move", icon = " ", color = "grey" },
            { pattern = "swap", icon = " ", color = "grey" },
            { pattern = "switch", icon = " ", color = "grey" },
            { pattern = "join", icon = "󰡍", color = "grey" },
            { pattern = "split", icon = "󰡏", color = "grey" },
            { pattern = "add", icon = "", color = "grey" },
            { pattern = "increase", icon = "", color = "grey" },
            { pattern = "remove", icon = "", color = "grey" },
            { pattern = "decrease", icon = "", color = "grey" },
            { pattern = "max", icon = "", color = "grey" },
            { pattern = "min", icon = "󰖰", color = "grey" },
          },
        },
        spec = {
          {
            mode = "n",
            { "]", group = "next" },
            { "[", group = "previous" },
            { "<leader>b", group = "buffer" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "find" },
            { "<leader>g", group = "git" },
            { "<leader>m", group = "notes (markdown)" },
            { "<leader>s", group = "substitute" },
            { "<leader>q", group = "session" },
            { "<localleader>,", group = "command" },
            { "<localleader>d", group = "database" },
            { "<localleader>f", group = "find" },
            { "<localleader>g", group = "git" },
            { "<localleader>i", group = "insert" },
            { "<localleader>m", group = "notes (markdown)" },
            { "<localleader>q", group = "quickfix (trouble)" },
            { "<localleader>s", group = "search" },
          },
          {
            mode = "v",
            { "<leader>g", group = "git" },
            { "<leader>m", group = "notes (markdown)" },
            { "<leader>s", group = "selection" },
            { "<localleader>i", group = "insert" },
          },
        },
      }
    end,
  },
  {
    "folke/zen-mode.nvim",
    lazy = true,
    dependencies = { "folke/twilight.nvim" },
    cmd = "ZenMode",
    opts = {
      window = {
        options = {
          signcolumn = "yes",
          number = true,
          relativenumber = false,
          cursorline = true,
          cursorcolumn = false,
          foldcolumn = "0",
          list = true,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
        },
        twilight = { enabled = true },
        tmux = { enabled = false },
        kitty = {
          enabled = true,
          font = "+4",
        },
      },
      on_close = function() vim.cmd.doautocmd "BufWinEnter" end,
    },
  },
}
