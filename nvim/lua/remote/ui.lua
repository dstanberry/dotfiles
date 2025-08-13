return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "akinsho/bufferline.nvim",
    event = { "LazyFile", { event = "BufReadCmd", pattern = "octo://*" } },
    lazy = vim.fn.argc(-1) == 0,
    keys = {
      { "<left>", "<cmd>BufferLineCyclePrev<cr>", desc = "bufferline: goto next buffer" },
      { "<right>", "<cmd>BufferLineCycleNext<cr>", desc = "bufferline: goto previous buffer" },
      { "<leader>bg", ":BufferLineGroupToggle ", desc = "bufferline: toggle group" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "bufferline: toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "bufferline: delete all non-pinned buffers" },
    },
    config = function()
      local bufferline_groups = require "bufferline.groups"
      local bufferline = require "bufferline"
      bufferline.setup {
        highlights = function(defaults)
          local hl = ds.tbl_reduce(defaults.highlights, function(highlight, attrs, name)
            local formatted = name:lower()
            local is_group = formatted:match "group"
            local is_offset = formatted:match "offset"
            local is_separator = formatted:match "separator"
            if not is_group or (is_group and is_separator) then attrs.bg = vim.g.ds_colors.bg2 end
            if is_separator and not (is_group or is_offset) then attrs.fg = vim.g.ds_colors.bg2 end
            highlight[name] = attrs
            return highlight
          end)
          hl.buffer_selected.italic = false
          hl.buffer_visible.bold = true
          hl.buffer_visible.italic = false
          hl.buffer_visible.fg = vim.g.ds_colors.gray1
          hl.tab_selected.bold = true
          hl.tab_selected.fg = vim.g.ds_colors.red1
          return hl
        end,
        options = {
          style_preset = { bufferline.style_preset.minimal },
          mode = "buffers",
          numbers = "none",
          left_mouse_command = "buffer %d",
          ---@diagnostic disable-next-line: assign-type-mismatch
          right_mouse_command = nil,
          middle_mouse_command = function(buf) ds.buffer.delete(buf) end,
          close_command = function(buf) ds.buffer.delete(buf) end,
          buffer_close_icon = ds.icons.misc.Close .. ds.icons.misc.BrailleBlank,
          close_icon = ds.icons.misc.CloseBold .. ds.icons.misc.BrailleBlank,
          hover = { enabled = true, reveal = { "close" } },
          left_trunc_marker = ds.icons.misc.LeftArrowCircled,
          right_trunc_marker = ds.icons.misc.RightArrowCircled,
          max_name_length = 20,
          color_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          sort_by = "insert_after_current",
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, _, ctx)
            if ctx.buffer:current() then return "" end
            return ds.pad(ds.icons.diagnostics.Warn, "left")
          end,
          indicator = {
            icon = ds.pad(ds.icons.misc.VerticalBarMiddle, "right"),
            style = "none",
          },
          get_element_icon = function(element)
            local mini_icons = package.loaded["mini.icons"]
            if not mini_icons then return ds.icons.status.Error end
            if element.filetype == "octo" or element.path:match "^octo:" then
              return mini_icons.get("extension", element.filetype)
            end
            return mini_icons.get(element.directory and "directory" or "file", element.path)
          end,
          offsets = {
            {
              text = ds.pad(ds.icons.kind.Copilot, "right") .. "COPILOT CHAT",
              filetype = "copilot-chat",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Sql, "right") .. "DATABASE VIEWER",
              filetype = "dbui",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.StackFrame, "right") .. "DEBUGGER",
              filetype = "dapui_scopes",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Diff, "right") .. "DIFF VIEW",
              filetype = "DiffviewFiles",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Tree, "right") .. "EXPLORER",
              filetype = "snacks_layout_box",
              highlight = "PanelHeading",
              separator = true,
            },
            {
              text = ds.pad(ds.icons.misc.Magnify, "right") .. "FIND / REPLACE",
              filetype = "grug-far",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Tree, "right") .. "SYMBOLS",
              filetype = "trouble",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
          },
          groups = {
            items = {
              {
                name = "Notes",
                highlight = { fg = vim.g.ds_colors.overlay1 },
                auto_close = false,
                matcher = function(buf)
                  return (vim.env.ZK_NOTEBOOK_DIR and vim.env.ZK_NOTEBOOK_DIR ~= "")
                      and vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR)
                    or buf.path:match "zettelkasten"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "SQL",
                auto_close = false,
                highlight = { fg = vim.g.ds_colors.orange0 },
                matcher = function(buf) return buf.name:match "%.sql$" end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "Unit Tests",
                highlight = { fg = vim.g.ds_colors.rose1 },
                auto_close = false,
                matcher = function(buf)
                  return buf.name:match "_spec%."
                    or buf.name:match "%.spec"
                    or buf.name:match "_test%."
                    or buf.name:match "%.test"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              bufferline_groups.builtin.pinned:with { icon = ds.icons.groups.Pinned },
              bufferline_groups.builtin.ungrouped,
            },
          },
        },
      }
    end,
  },
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
          border = { style = "rounded" },
          position = { col = "50%", row = 20 },
          size = { height = "auto", min_width = 70 },
        },
        cmdline_popupmenu = {
          border = { style = "rounded" },
          position = { row = 23, col = "50%" },
          size = { width = 70, height = 10 },
          win_options = { winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" } },
        },
        mini = {
          position = { row = -2 },
          win_options = { winblend = vim.o.pumblend },
        },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then vim.cmd [[messages clear]] end
      require("noice").setup(opts)
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "copilot-chat", "markdown", "octo" },
    opts = {
      dash = { width = 80 },
      code = {
        border = "block",
        highlight = "@markup.codeblock",
        highlight_border = "@markup.codeblock",
        highlight_inline = "@markup.raw.markdown_inline",
        left_pad = 2,
        min_width = 80,
        right_pad = 2,
        inline_pad = 1,
        sign = false,
        style = "normal",
        width = "block",
      },
      heading = {
        border = true,
        sign = false,
        width = "block",
        min_width = 80,
        icons = vim.tbl_map(function(i) return ds.pad(ds.icons.markdown["H" .. i], "right") end, vim.fn.range(1, 8)),
      },
      pipe_table = {
        head = "@markup.table",
        row = "@markup.table",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoQuickFix", "TodoTrouble" },
    opts = {
      signs = false,
      sign_priority = 0,
      colors = {
        error = { ds.color.blend(vim.g.ds_colors.red1, vim.g.ds_colors.gray1, 0.31) },
        warning = { ds.color.blend(vim.g.ds_colors.rose0, vim.g.ds_colors.gray1, 0.31) },
        info = { ds.color.blend(vim.g.ds_colors.magenta1, vim.g.ds_colors.gray1, 0.31) },
        hint = { ds.color.blend(vim.g.ds_colors.aqua1, vim.g.ds_colors.gray1, 0.31) },
        default = { ds.color.blend(vim.g.ds_colors.blue0, vim.g.ds_colors.gray1, 0.31) },
        test = { ds.color.blend(vim.g.ds_colors.green0, vim.g.ds_colors.gray1, 0.31) },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "LazyFile",
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
    "stevearc/oil.nvim",
    keys = function()
      local _open = function() require("oil").open(ds.root.get()) end
      local _float = function() require("oil").toggle_float() end

      return {
        { "-", _open, desc = "oil: browse project" },
        { "<leader>-", _float, desc = "oil: browse parent directory" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            require("remote.lsp.handlers").on_rename(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
    opts = {
      default_file_explorer = true,
      autosave_changes = false,
      delete_to_trash = false,
      skip_confirm_for_simple_edits = true,
      columns = { "icon" },
      keymaps = {
        ["<a-c>"] = "actions.open_cwd",
        ["<a-h>"] = "actions.toggle_hidden",
        ["<c-h>"] = false,
        ["<c-t>"] = { "actions.select", opts = { tab = true } },
        ["<c-s>"] = { "actions.select", opts = { vertical = true } },
        ["-"] = "actions.parent",
        ["_"] = false,
        ["g."] = false,
        ["q"] = "actions.close",
      },
      float = {
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
        max_width = math.floor(vim.o.columns * 0.35),
        max_height = math.floor(vim.o.lines * 0.4),
        win_options = {
          cursorline = false,
          number = false,
          relativenumber = false,
          winblend = vim.o.pumblend,
          winhighlight = "Title:OilFloatTitle",
        },
      },
      keymaps_help = {
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
      },
      preview = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
      ssh = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "BufReadPre",
    opts = {
      char = ds.icons.misc.VerticalBarRight,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        preset = "helix",
        win = {
          border = vim.tbl_map(function(icon) return { icon, "WhichKeyBorder" } end, ds.icons.border.Default),
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
            { pattern = "buffer", icon = " ", color = "purple" },
            { pattern = "find", icon = " ", color = "green" },
            { pattern = "git", icon = " ", color = "green" },
            { pattern = "harpoon", icon = "󰛢 ", color = "cyan" },
            { pattern = "octo", icon = " ", color = "green" },
            { pattern = "search", icon = " ", color = "green" },
            { plugin = "grug-far", icon = " ", color = "blue" },
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
            { "<leader>w", group = "window" },
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
}
