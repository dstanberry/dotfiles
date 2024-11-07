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
    keys = function()
      local _scroll_up = function()
        if not require("noice.lsp").scroll(4) then return "<c-d>" end
      end
      local _scroll_down = function()
        if not require("noice.lsp").scroll(-4) then return "<c-f>" end
      end

      return {
        { "<c-d>", _scroll_up, mode = "n", expr = true, desc = "noice: scroll down" },
        { "<c-f>", _scroll_down, mode = "n", expr = true, desc = "noice: scroll up" },
      }
    end,
    opts = {
      cmdline = {
        format = {
          cmdline = { title = "" },
          filter = { title = "" },
          help = { title = "" },
          lua = { title = "" },
          input = { title = "", view = "cmdline_popup", lang = "text" },
          search_down = { title = "", view = "cmdline", lang = "regex" },
          search_up = { title = "", view = "cmdline", lang = "regex" },
          substitute = {
            title = "",
            pattern = "^:'?<?,?'?>?%%?s/",
            icon = ds.icons.misc.ArrowSwap,
            ft = "regex",
            kind = "search",
            view = "cmdline",
          },
          IncRename = {
            title = "",
            pattern = "^:%s*IncRename%s+",
            icon = ds.icons.misc.Pencil,
            conceal = true,
            opts = {
              relative = "cursor",
              size = { min_width = 20 },
              position = { row = -3, col = 0 },
            },
          },
        },
      },
      lsp = {
        documentation = {
          enabled = true,
          opts = {
            border = { style = ds.icons.border.Default },
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
              { event = "notify", find = "No information available" },
              {
                event = "lsp",
                cond = function(message)
                  local content = message:content()
                  local skipped = {
                    "unknown command",
                    "Ruff encountered a problem",
                  }
                  for _, pattern in ipairs(skipped) do
                    if vim.bo[vim.api.nvim_get_current_buf()].filetype == "python" and content:find(pattern) then
                      return true
                    end
                  end
                  return false
                end,
              },
            },
          },
        },
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
          size = { min_width = 70, height = "auto" },
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
    init = function()
      if not ds.plugin.is_installed "noice.nvim" then
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function() vim.notify = require "notify" end,
        })
      end
    end,
    opts = {
      -- stages = "fade_in_slide_out",
      stages = "static",
      timeout = 3000,
      background_colour = "Normal",
      render = function(...)
        local n = select(2, ...)
        local style = n.title[1] == "" and "minimal" or "wrapped-compact"
        require("notify.render")[style](...)
      end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
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
        table.insert(result, { ds.pad(ds.icons.misc.Ellipses, "both"), "Comment" })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, "" })
        return result
      end,
      provider_selector = function() return { "treesitter", "indent" } end,
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
            { "<leader>s", group = "search" },
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
