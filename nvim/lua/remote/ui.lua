return {
  {
    "uga-rosa/ccc.nvim",
    lazy = true,
    cmd = { "CccHighlighterToggle" },
    ft = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "lua",
      "typescript",
      "typescriptreact",
    },
    opts = function(plugin)
      return {
        highlighter = {
          auto_enable = true,
          filetypes = plugin.ft,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<localleader>gd",
        function()
          local view = require("diffview.lib").get_current_view()
          if view then
            vim.cmd "DiffviewClose"
          else
            vim.cmd "DiffviewOpen"
          end
        end,
        desc = "diffview: toggle diff",
      },
      { "<localleader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview: file history" },
      { "<localleader>gH", [[:'<'>DiffviewFileHistory<cr>]], mode = "v", desc = "diffview: file history" },
    },
    init = function()
      ds.hl.new("DiffviewFilePanelTitle", { link = "@markup.environment" })
      ds.hl.new("DiffviewFilePanelCounter", { link = "Normal" })
      ds.hl.new("DiffviewHash", { link = "Boolean" })
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
          folder_closed = ds.pad(vim.g.ds_icons.documents.FolderOutlineClosed, "right"),
          folder_open = ds.pad(vim.g.ds_icons.documents.FolderOutlineClosed, "right"),
        },
        signs = {
          fold_closed = vim.g.ds_icons.misc.FoldClosed,
          fold_open = vim.g.ds_icons.misc.FoldOpened,
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
    config = function()
      local function get_height(self, _, max_lines)
        local results = #self.finder.results
        local PADDING = 4
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
      end

      require("dressing").setup {
        input = {
          enabled = false,
          insert_only = false,
          title_pos = "left",
          border = "single",
          relative = "editor",
          prefer_width = 60,
          win_options = {
            winblend = 0,
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
      indent = {
        -- char = "",
        char = vim.g.ds_icons.misc.VerticalBarThin,
        -- tab_char =vim.g.ds_icons.misc.VerticalBarThin,
      },
      scope = {
        enabled = true,
        char = vim.g.ds_icons.misc.VerticalBar,
        highlight = {
          "TSRainbow1",
          "TSRainbow2",
          "TSRainbow3",
          "TSRainbow4",
          "TSRainbow5",
          "TSRainbow6",
          "TSRainbow7",
        },
      },
      exclude = {
        filetypes = vim.tbl_deep_extend(
          "keep",
          vim.g.ds_excludes.ft.stl_disabled,
          vim.g.ds_excludes.ft.wb_disabled,
          vim.g.ds_excludes.ft.wb_empty,
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
    keys = {
      {
        "<c-d>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-d>" end
        end,
        mode = "n",
        expr = true,
        desc = "noice: scroll down",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-f>" end
        end,
        mode = "n",
        expr = true,
        desc = "noice: scroll up",
      },
    },
    init = function()
      ds.hl.new("NoiceFormatProgressTodo", { bg = ds.color.blend(vim.g.ds_colors.blue1, vim.g.ds_colors.grayX, 0.20) })
      ds.hl.new("NoiceFormatProgressDone", { bg = vim.g.ds_colors.blue0 })
      ds.hl.new("NoiceFormatEvent", { link = "Comment" })
      ds.hl.new("NoiceFormatKind", { link = "Comment" })
      vim.g.lua_show_progress = true
    end,
    opts = {
      cmdline = {
        format = {
          cmdline = { title = "" },
          filter = { title = "" },
          help = { title = "" },
          input = { title = "", view = "cmdline_popup", lang = "text" },
          lua = { title = "" },
          search_down = { title = "", view = "cmdline" },
          search_up = { title = "", view = "cmdline" },
          IncRename = {
            title = "",
            pattern = "^:%s*IncRename%s+",
            icon = vim.g.ds_icons.misc.Pencil,
            conceal = true,
            opts = {
              relative = "cursor",
              size = { min_width = 20 },
              position = { row = -3, col = 0 },
            },
          },
          substitute = {
            pattern = "^:%%?s/",
            icon = vim.g.ds_icons.misc.ArrowSwap,
            ft = "regex",
            kind = "search",
            title = "",
          },
        },
      },
      lsp = {
        documentation = {
          enabled = true,
          opts = {
            border = { style = vim.g.ds_icons.border.Default },
            position = { row = 2 },
            win_options = { winhighlight = { FloatBorder = "FloatBorderSB" } },
          },
        },
        hover = { enabled = true },
        signature = {
          enabled = true,
          opts = {
            position = { row = 2 },
          },
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
          filter = {
            any = {
              { event = "msg_show", find = "%d+ change" },
              { event = "msg_show", find = "%d+ line" },
              { event = "msg_show", find = "%d+ lines, %d+ bytes" },
              { event = "msg_show", find = "%d+ more line" },
              { event = "msg_show", find = "%d+L, %d+B" },
              { event = "msg_show", find = "search hit" },
              { event = "msg_show", find = "written" },
              { event = "msg_show", kind = "search_count" },
              {
                event = "lsp",
                kind = "progress",
                cond = function(msg)
                  local client = vim.tbl_get(msg.opts, "progress", "client")
                  local skipped = not vim.g.lua_show_progress and vim.tbl_contains({ "lua_ls" }, client)
                  vim.defer_fn(function() vim.g.lua_show_progress = false end, 10000)
                  return skipped
                end,
              },
            },
          },
        },
        {
          view = "cmdline_output",
          opts = { lang = "lua" },
          filter = {
            any = {
              { event = "msg_show", min_height = 10 },
              { event = "notify", min_height = 10 },
            },
          },
        },
        {
          view = "mini",
          filter = {
            any = {
              { event = "msg_show", find = "^E486:" },
              { event = "msg_show", find = "^Hunk %d+ of %d" },
            },
          },
        },
        {
          view = "notify",
          opts = { title = "", merge = true },
          filter = {
            any = {
              { event = "msg_showmode" },
              { kind = { "emsg", "echo", "echomsg" } },
            },
          },
        },
        {
          view = "notify",
          filter = {
            any = {
              { warning = true },
              { event = "msg_show", find = "^Warn" },
              { event = "msg_show", find = "^W%d+:" },
              { event = "msg_show", find = "^No hunks$" },
            },
          },
        },
        {
          view = "notify",
          filter = {
            any = {
              { error = true },
              { event = "msg_show", find = "^E%d+:" },
              { event = "msg_show", find = "^Error" },
            },
          },
        },
      },
      commands = {
        history = { view = "split" },
      },
      views = {
        cmdline_popup = {
          border = { style = "single", padding = { 0, 1 } },
          position = { row = 20, col = "50%" },
          size = { width = 70, height = "auto" },
          filter_options = {},
        },
        popupmenu = {
          relative = "editor",
          border = { style = "single", padding = { 0, 1 } },
          position = { row = 23, col = "50%" },
          size = { width = 70, height = 10 },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
          },
        },
        mini = {
          timeout = 1000,
          position = { row = -2 },
          border = { style = "rounded" },
          win_options = {
            winblend = vim.api.nvim_get_option_value("winblend", { scope = "global" }),
            winhighlight = { FloatBorder = "Comment" },
          },
        },
        split = {
          win_options = {
            winhighlight = { Normal = "NormalSB" },
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      stages = "fade_in_slide_out",
      timeout = 3000,
      background_colour = "Normal",
      render = function(...)
        local n = select(2, ...)
        local style = n.title[1] == "" and "minimal" or "default"
        require("notify.render")[style](...)
      end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    init = function()
      ds.hl.new("NotifyTRACEBody", { link = "NormalFloat" })
      ds.hl.new("NotifyTRACEBorder", { link = "FloatBorder" })
      ds.hl.new("NotifyTRACEIcon", { link = "@markup" })
      ds.hl.new("NotifyTRACETitle", { link = "@markup" })

      ds.hl.new("NotifyDEBUGBody", { link = "NormalFloat" })
      ds.hl.new("NotifyDEBUGBorder", { link = "FloatBorder" })
      ds.hl.new("NotifyDEBUGIcon", { link = "Debug" })
      ds.hl.new("NotifyDEBUGTitle", { link = "Debug" })

      ds.hl.new("NotifyINFOBody", { link = "NormalFloat" })
      ds.hl.new("NotifyINFOBorder", { link = "FloatBorder" })
      ds.hl.new("NotifyINFOIcon", { link = "String" })
      ds.hl.new("NotifyINFOTitle", { link = "String" })

      ds.hl.new("NotifyWARNBody", { link = "NormalFloat" })
      ds.hl.new("NotifyWARNBorder", { link = "FloatBorder" })
      ds.hl.new("NotifyWARNIcon", { link = "WarningMsg" })
      ds.hl.new("NotifyWARNTitle", { link = "WarningMsg" })

      ds.hl.new("NotifyERRORBody", { link = "NormalFloat" })
      ds.hl.new("NotifyERRORBorder", { link = "FloatBorder" })
      ds.hl.new("NotifyERRORIcon", { link = "ErrorMsg" })
      ds.hl.new("NotifyERRORTitle", { link = "ErrorMsg" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "notify",
        callback = function() vim.opt_local.cursorline = false end,
      })

      if not ds.lazy.is_installed "noice.nvim" then
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function() vim.notify = require "notify" end,
        })
      end
    end,
  },
  {
    "levouh/tint.nvim",
    event = "LazyFile",
    opts = function()
      return {
        tint = -10,
        highlight_ignore_patterns = {
          "Comment",
          "NeoTree.*",
          "Panel.*",
          "Status.*",
          "Telescope.*",
          "Trouble.*",
          "WinSeparator",
        },
        window_ignore_function = function(win_id)
          if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= "" then return true end
          local buf = vim.api.nvim_win_get_buf(win_id)
          local b = vim.bo[buf]
          local ignore_bt = vim.g.ds_excludes.bt.wb_disabled
          local ignore_ft =
            vim.tbl_deep_extend("keep", vim.g.ds_excludes.ft.stl_disabled, vim.g.ds_excludes.ft.wb_disabled)
          return ds.any(ignore_bt, function(item) return b.bt:match(item) end)
            or ds.any(ignore_ft, function(item) return b.ft:match(item) end)
        end,
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoQuickFix", "TodoTelescope", "TodoTrouble" },
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
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
    enabled = true,
    keys = {
      -- { "zR", function() require("ufo").openAllFolds() end, desc = "ufo: open all folds" },
      -- { "zM", function() require("ufo").closeAllFolds() end, desc = "ufo: close all folds" },
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
          winblend = 0,
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
        table.insert(result, { ds.pad(vim.g.ds_icons.misc.Ellipses, "both"), "Comment" })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, "" })
        return result
      end,
      provider_selector = function() return { "treesitter", "indent" } end,
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "LazyFile",
    init = function() ds.hl.new("VirtColumn", { link = "NonText" }) end,
    opts = { char = vim.g.ds_icons.misc.VerticalBarVeryThin },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      layout = {
        align = "center",
      },
      plugins = {
        spelling = {
          enabled = true,
        },
      },
      window = {
        border = vim.g.ds_icons.border.Default,
      },
    },
    init = function()
      local BLUE_DARK = ds.color.blend(vim.g.ds_colors.blue2, vim.g.ds_colors.bg0, 0.08)

      ds.hl.new("WhichKeyFloat", { bg = BLUE_DARK })
      ds.hl.new("WhichKeyBorder", { fg = vim.g.ds_colors.gray0, bg = BLUE_DARK })
      ds.hl.new("WhichKeySeparator", { fg = ds.color.lighten(vim.g.ds_colors.gray1, 20) })
      ds.hl.new("WhichKeyDesc", { link = "Constant" })
      ds.hl.new("WhichKeyGroup", { link = "Identifier" })
    end,
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
        mode = "n",
        ["]"] = { name = "+next" },
        ["["] = { name = "+previous" },
        ["<leader>"] = {
          b = { name = "+buffer" },
          d = { name = "+debug" },
          f = { name = "+file/find" },
          g = { name = "+git" },
          h = { name = "+marks" },
          m = { name = "+notes (markdown)" },
          s = { name = "+search" },
          q = { name = "+session" },
        },
        ["<localleader>"] = {
          ["<localleader>"] = { name = "+command" },
          d = { name = "+database" },
          f = { name = "+file/find" },
          g = { name = "+git" },
          m = { name = "+notes (markdown)" },
          q = { name = "+quickfix (trouble)" },
          s = { name = "+search" },
        },
      }
      wk.register {
        mode = "v",
        ["<leader>"] = {
          m = { name = "+notes (markdown)" },
          s = { name = "+selection" },
        },
        ["<localleader>"] = {
          g = { name = "+git" },
          m = { name = "+notes (markdown)" },
        },
      }
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    lazy = true,
    dependencies = { "folke/twilight.nvim" },
    opts = {
      window = {
        options = {
          signcolumn = "yes",
          number = true,
          relativenumber = true,
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
